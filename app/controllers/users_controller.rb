class UsersController < ApplicationController
  before_action :set_user, only: [:show, :likes, :items, :orders]
  before_action :authenticate_user!
  before_action :contributor_confirmation
  layout 'user'
  def show
  end

  def likes
  end

  def items
  end

  def orders
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def contributor_confirmation
    redirect_to root_path unless current_user == @user
  end
end
