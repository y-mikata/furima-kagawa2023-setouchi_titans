class OrdersController < ApplicationController
  before_action :set_item, only: [:index, :create]
  before_action :authenticate_user!
  before_action :set_user, only: [:index, :create]
  before_action :set_cards, only: [:index, :create, :toggle_card_list, :refresh_card_frame]
  before_action :set_selected_card, only: [:index, :create, :set_card, :toggle_card_list, :refresh_card_frame]
  before_action :check_if_sold, only: :index
  before_action :contributor_check, only: :index

  def index
    @order_address = OrderAddress.new
    return if session[:selected_card_id]

    session[:selected_card_id] = @default_card&.id
  end

  def create
    @order_address = OrderAddress.new(order_params)
    if @order_address.valid?
      pay_item
      @order_address.save
      session.delete(:selected_card_id)
      redirect_to root_path
    else
      render 'index', status: :unprocessable_entity
    end
  end

  def set_card
    session[:selected_card_id] = params[:selected_card_id]
    render json: { message: 'Payment method set successfully.' }
  end

  def toggle_card_list
    @show_card_list = ActiveModel::Type::Boolean.new.cast(params[:show_card_list])

    respond_to(&:turbo_stream)
  end

  def refresh_card_frame
    respond_to(&:turbo_stream)
  end

  def clear_session
    session.delete(:selected_card_id)
    head :ok
  end

  private

  def order_params
    params.require(:order_address).permit(:postal_code, :prefecture_id, :city, :block, :building, :phone_number).merge(
      item_id: params[:item_id], user_id: current_user.id, card_id: @selected_card
    )
  end

  def set_item
    @item = Item.find(params[:item_id])
  end

  def set_cards
    @cards = current_user.cards
    @default_card = current_user.cards.find_by(is_default: true)
    gon.default_card = @default_card
  end

  def set_selected_card
    @selected_card =   current_user.cards.find_by(id: session[:selected_card_id]) ||
                       current_user.cards.find_by(is_default: true)
  end

  def set_user
    @user = current_user
  end

  def pay_item
    @item.with_lock do
      Payjp.api_key = ENV['PAYJP_SECRET_KEY']
      payjp_customer = Payjp::Customer.retrieve(current_user.payjp_customer_id)
      selected_card_id = @selected_card
      card = current_user.cards.find_by(id: selected_card_id)

      if card.present?
        Payjp::Charge.create(
          amount: @item.price, # 商品の値段
          customer: payjp_customer, # カードトークン
          card: card.card_id,
          currency: 'jpy' # 通貨の種類（日本円）
        )
      end
    end
  end

  def check_if_sold
    redirect_to root_path if @item.order.present?
  end

  def contributor_check
    redirect_to root_path if current_user == @item.user
  end
end
