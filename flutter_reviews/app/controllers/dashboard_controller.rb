class DashboardController < ApplicationController
  allow_unauthenticated_access only: [:show]
  def show
    @reviews = Review.all.includes(:user)
    @most_liked_reviews = @reviews.order(likes_count: :desc).limit(3)
    
    # Fetch top rated books based on average rating, excluding those without ratings from database
    @top_rated_books = Review
                           .where.not(rating: nil)
                           .group('google_book_id')
                           .select('google_book_id, AVG(rating) as average_rating')
                           .order('AVG(reviews.rating) DESC')
                           .limit(10)
    
    # Fetch book details from Google Books API for each top rated book
    @book_details = @top_rated_books.map do |record|
      api_data = fetch_book(record.google_book_id) 
      {
        title: api_data["volumeInfo"]["title"],
        authors: api_data["volumeInfo"]["authors"],
        average_rating: record.average_rating
      }
        end
  end  

  def fetch_book(book_id)
      url = "https://www.googleapis.com/books/v1/volumes/#{book_id}?key=#{ENV['GOOGLE_BOOKS_KEY']}&country=US"
      response = HTTParty.get(url, verify: false)
      JSON.parse(response.body.force_encoding("UTF-8"))
  end
end
