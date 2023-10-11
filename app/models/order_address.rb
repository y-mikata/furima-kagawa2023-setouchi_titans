class OrderAddress
  include ActiveModel::Model
  attr_accessor :postal_code,
                :prefecture,
                :city,
                :block,
                :building,
                :phone_number,
                :order_id,
                :item_id,
                :user_id

  with_options presence: true do
    validates :price, numericality: {only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 1000000, message: 'is invalid'}
    validates :user_id
    validates :postal_code, format: {with: /\A[0-9]{3}-[0-9]{4}\z/, message: "is invalid. Include hyphen(-)"}
  end
  validates :prefecture, numericality: {other_than: 0, message: "can't be blank"}

  def save
    order = Order.create(item_id: item_id, user_id: user_id)
    Address.create(postal_code: postal_code, prefecture: prefecture, city: city, block: block, building: building, phone_number: phone_number, order_id: order_id,)
  end
end
