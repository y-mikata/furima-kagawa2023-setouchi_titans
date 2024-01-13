class UsersController < ApplicationController
  before_action :set_user, only: [:show, :likes, :items, :orders, :cards]
  layout 'user'
  def show
  end

  def likes
  end

  def items
  end

  def orders
  end

  def cards
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
