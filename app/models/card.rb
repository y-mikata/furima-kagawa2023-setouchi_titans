class Card < ApplicationRecord
  belongs_to :user
  attr_accessor :token

  validates :token, presence: true, on: :create
  encrypts :brand, :last4, :exp_month, :exp_year

  # Expiration Date Check
  def expired?
    Date.new(exp_year.to_i, exp_month.to_i, 1) < Date.today
  end
end
