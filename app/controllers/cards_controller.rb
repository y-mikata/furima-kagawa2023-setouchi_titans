class CardsController < ApplicationController
  before_action :set_user

  def index
    @cards = current_user.cards
  end

  def new
  end

  def create
    Payjp.api_key = ENV['PAYJP_SECRET_KEY']

    if params[:token].blank?
      redirect_to new_user_card_path(current_user), alert: 'No card token provided. Please try again.'
      return
    end

    if current_user.payjp_customer_id
      customer = Payjp::Customer.retrieve(current_user.payjp_customer_id)
      payjp_card = customer.cards.create(card: params[:token])
    else
      customer = Payjp::Customer.create(
        email: current_user.email,
        description: "Customer association for user_id #{current_user.id}",
        card: params[:token]
      )
      current_user.update_column(:payjp_customer_id, customer.id)
      payjp_card = customer.cards.data.first
    end

    card = current_user.cards.build(
      token: params[:token],
      card_id: payjp_card.id,
      brand: payjp_card.brand,
      last4: payjp_card.last4,
      exp_month: payjp_card.exp_month, exp_year: payjp_card.exp_year,
      is_default: payjp_card.id == customer.default_card
    )

    if card.save
      redirect_to user_cards_path(current_user), notice: 'Card successfully added.'
    else
      redirect_to new_user_card_path(current_user), alert: 'Unable to add card.'
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
    @user = User.find(params[:user_id])
  end
end
