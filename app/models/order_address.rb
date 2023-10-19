class OrderAddress
  include ActiveModel::Model
  attr_accessor :postal_code,
                :prefecture_id,
                :city,
                :block,
                :building,
                :phone_number,
                :item_id,
                :user_id,
                :token

  with_options presence: true do
    validates :user_id
    validates :item_id
    validates :token
    validates :postal_code, format: { with: /\A[0-9]{3}-[0-9]{4}\z/, message: 'is invalid. Enter it as follows (e.g. 123-4567)' }
    validates :prefecture_id, numericality: { other_than: 1, message: "can't be blank" }
    validates :city
    validates :block
    validates :phone_number, length: { in: 10..11, message: 'is too short' },
                             format: { with: /\A[0-9]+\z/, message: 'is invalid. Input only numbers' }
  end

  def save
    order = Order.create(item_id:, user_id:)
    Address.create(postal_code:, prefecture_id:, city:, block:, building:,
                   phone_number:, order_id: order.id)
  end
end
