module Cards
  class CreateService
    def initialize(user:, token:)
      @user = user
      @token = token
    end

    def call
      return OpenStruct.new(success?: false, error: 'No card token provided. Please try again.') if @token.blank?

      setup_payjp

      customer, payjp_card = find_or_create_customer_and_card

      return OpenStruct.new(success?: false, error: payjp_card) unless payjp_card.is_a?(Payjp::Card)

      card = build_card(payjp_card, customer)

      if card.save
        OpenStruct.new(success?: true, card:)
      else
        Rails.logger.debug card.errors.full_messages.to_sentence
        OpenStruct.new(success?: false, error: 'Unable to add card.')
      end
    end

    private

    def setup_payjp
      Payjp.api_key = ENV['PAYJP_SECRET_KEY']
    end

    def find_or_create_customer_and_card
      if @user.payjp_customer_id
        customer = Payjp::Customer.retrieve(@user.payjp_customer_id)
        payjp_card = create_or_find_card(customer)
      else
        customer = Payjp::Customer.create(email: @user.email, description: "Customer for user_id #{@user.id}", card: @token)
        @user.update_column(:payjp_customer_id, customer.id)
        payjp_card = customer.cards.data.first
      end
      [customer, payjp_card]
    end

    def create_or_find_card(customer)
      customer.cards.create(card: @token)
    rescue Payjp::InvalidRequestError => e
      e.message.include?('already has the same card') ? 'You have already added this card.' : raise(e)
    end

    def build_card(payjp_card, customer)
      @user.cards.build(
        token: @token,
        card_id: payjp_card.id,
        brand: payjp_card.brand,
        last4: payjp_card.last4,
        exp_month: payjp_card.exp_month,
        exp_year: payjp_card.exp_year,
        is_default: payjp_card.id == customer.default_card
      )
    end
  end
end
