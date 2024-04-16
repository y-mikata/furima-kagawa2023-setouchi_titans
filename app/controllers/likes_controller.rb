class LikesController < ApplicationController
  before_action :set_item

  def like
    like = current_user.likes.new(item_id: @item.id)
    return unless like.save

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.update("like-link-#{@item.id}",
                                                 partial: 'likes/like', locals: { item: @item })
      end
    end
  end

  def unlike
    like = current_user.likes.find_by(item_id: @item.id)
    return unless like&.destroy

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.update("like-link-#{@item.id}",
                                                 partial: 'likes/like', locals: { item: @item })
      end
    end
  end

  private

  def set_item
    @item = Item.find(params[:id])
  end
end
