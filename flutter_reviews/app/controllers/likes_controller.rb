class LikesController < ApplicationController
  before_action :require_authentication
  before_action :set_review
  def create
    @like = @review.likes.build(user: Current.user)
    if @like.save
      respond_to do |format|
        format.html { redirect_to book_reviews_path(params[:book_id]), notice: "Review liked." }
      end
    else
      respond_to do |format|
        format.html { redirect_to book_reviews_path(params[:book_id]), alert: "Unable to like review." }
      end
    end
  end

  def destroy
    @like = @review.likes.find(params[:id])
    @like.destroy!

    respond_to do |format|
      format.html {redirect_to book_reviews_path(params[:book_id]), notice: "Like removed.", status: :see_other }
    end
  end
  private
  def set_review
    @review = Review.find(params[:review_id])
  end
end