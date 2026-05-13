class ReviewsController < ApplicationController
  before_action :set_review, only: %i[ show edit update destroy ]

  # GET /reviews or /reviews.json
  def index
    @reviews = Review.where(google_book_id: params[:book_id])
    @book_details = fetch_book_details(params[:book_id])
  end

  # GET /reviews/1 or /reviews/1.json
  def show
  end

  # GET /reviews/new
  def new
    @review = Review.new
      
  end

  # GET /reviews/1/edit
  def edit
  end

  # POST /reviews or /reviews.json
  def create
    @review = Review.new(review_params.merge(google_book_id: params[:book_id]))
    respond_to do |format|
      if @review.save
        format.html { redirect_to book_path(params[:book_id]), notice: "Review was successfully submitted." }
        format.json { render :new, status: :created, location: @review }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reviews/1 or /reviews/1.json
  def update
    respond_to do |format|
      if @review.update(review_params)
        format.html { redirect_to book_review_path(@review.google_book_id, @review), notice: "Review was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @review }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reviews/1 or /reviews/1.json
  def destroy
    @review.destroy!

    respond_to do |format|
      format.html { redirect_to book_reviews_path(params[:book_id]), notice: "Review was successfully deleted.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_review
      @review = Review.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def review_params
      params.require(:review).permit(:rating, :comment)
    end

    def fetch_book_details(book_id)
      url = "https://www.googleapis.com/books/v1/volumes/#{book_id}?key=#{ENV['GOOGLE_BOOKS_KEY']}&country=US"
      response = HTTParty.get(url, verify: false)
      JSON.parse(response.body.force_encoding("UTF-8"))
    end
end
