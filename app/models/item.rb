class Item < ApplicationRecord
  validates :name, presence: true
  validates :info, presence: true
  # validates :category_id, presence: true
  # validates :condition_id, presence: true
  validates :price, presence: true
  # validates :postage_type_id, presence: true
  # validates :prefecture_id, presence: true
  # validates :shipping_time_id, presence: true
  
  belongs_to :user
  # has_one :order
  
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :genre
end
