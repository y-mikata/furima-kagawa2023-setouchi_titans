class Item < ApplicationRecord
  validates :name, :info, :image, presence: true
  validates :price, presence: true, 
    numericality: { 
      only_integer: true, 
      greater_than_or_equal_to: 300, 
      less_than_or_equal_to: 9_999_999
    }

  belongs_to :user
  # has_one :order
  has_one_attached :image
  
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :category
  belongs_to :condition
  belongs_to :postage_type
  belongs_to :prefecture
  belongs_to :shipping_time

  validates :category_id, :condition_id, :postage_type_id, :prefecture_id,
   :shipping_time_id, numericality: { other_than: 1, message: "can't be blank" } 

end
