class Card < ApplicationRecord
  belongs_to :user
  attr_accessor :token

  validates :token, presence: true, on: :create
  encrypts :brand, :last4, :exp_month, :exp_year
end
