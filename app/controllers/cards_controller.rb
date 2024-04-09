class CardsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user
  before_action :user_existence_check
  before_action :contributor_confirmation

  def index
    @cards = current_user.cards
  end

  def new
  end

  def create
    result = Cards::CreateService.new(user: current_user, token: params[:token]).call

    if result.success?
      @card = result.card
      respond_to do |format|
        format.turbo_stream do
          if params[:context] == 'orders_top'
            @selected_card = @card
            render turbo_stream: turbo_stream.update('selected-card', partial: 'orders/selected_card',
                                                                      locals: { selected_card: @selected_card })
          elsif params[:context] == 'orders_card_list'
            render turbo_stream: turbo_stream.append('cards-container', partial: 'orders/new_card',
                                                                        locals: { cards: @cards, selected_card: @selected_card })
          else
            render turbo_stream: [
              turbo_stream.update('flash', partial: 'shared/flash_messages', locals: { notice: 'Card added' }),
              turbo_stream.append('cards-list', partial: 'cards/card', locals: { card: @card })
            ]
          end
        end

        format.html do
          redirect_to user_cards_path(current_user), notice: 'Card successfully added.'
        end
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    card = Card.find_by(id: params[:id], user_id: current_user.id)
    redirect_to user_cards_path(current_user), alert: 'Card not found.' and return if card.nil?

    Payjp.api_key = ENV['PAYJP_SECRET_KEY']
    begin
      customer = Payjp::Customer.retrieve(current_user.payjp_customer_id)
      customer_card = customer.cards.retrieve(card.card_id)
      customer_card.delete if customer_card.present?
      card.destroy
      customer = Payjp::Customer.retrieve(current_user.payjp_customer_id)
      new_default_card = customer.default_card
      if new_default_card != card.card_id
        new_default_card = current_user.cards.find_by(card_id: new_default_card)
        new_default_card&.update(is_default: true)
      end
      flash[:notice] = 'Card successfully deleted.'
      redirect_to user_cards_path(current_user)
    rescue Payjp::CardError => e
      flash[:alert] = "Failed to delete card: #{e.message}"
      redirect_to user_cards_path(current_user)
    end
  end

  def set_default
    Card.transaction do
      # Reset the default status of all cards
      current_user.cards.update_all(is_default: false)

      # Set the new default card
      card = current_user.cards.find_by(id: params[:id])
      if card
        Payjp.api_key = ENV['PAYJP_SECRET_KEY']
        customer = Payjp::Customer.retrieve(current_user.payjp_customer_id)
        customer.default_card = card.card_id
        if customer.save
          card.update!(is_default: true)
          redirect_to user_cards_path(current_user), notice: 'Default card updated successfully.'
        else
          redirect_to user_cards_path(current_user), alert: 'Failed to update default card on Payjp.'
        end
      else
        redirect_to user_cards_path(current_user), alert: 'Card not found.'
      end
    end
  rescue StandardError => e
    redirect_to user_cards_path(current_user), alert: "Failed to update default card: #{e.message}"
  end

  private

  def set_user
    @user = User.find_by(id: params[:user_id])
  end

  def user_existence_check
    redirect_to root_path if @user.nil?
  end

  def contributor_confirmation
    redirect_to root_path unless current_user == @user
  end
end
