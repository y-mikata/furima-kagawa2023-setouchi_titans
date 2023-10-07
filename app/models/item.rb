class Item < ApplicationRecord
  validates :name, :info, :price, presence: true
  
  belongs_to :user
  # has_one :order
  
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :genre

  validates :category_id, :condition_id, :postage_type_id, :prefecture_id,
   :shipping_time_id, numericality: { other_than: 1, message: "can't be blank" } 

end
