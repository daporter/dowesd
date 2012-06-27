class StaticPagesController < ApplicationController
  def home
    if signed_in?
      @txn        = current_user.txns.build(date: Date.today)
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
  end

  def about
  end

  def contact
  end
end
