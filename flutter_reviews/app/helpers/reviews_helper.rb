module ReviewsHelper
  def book_details(google_book_id)

    url = "https://www.googleapis.com/books/v1/volumes/#{google_book_id}?key=#{ENV['GOOGLE_BOOKS_KEY']}&country=US"
    response = HTTParty.get(url, verify: true)
    return {} unless response.code == 200

    JSON.parse(response.body.force_encoding("UTF-8"))
  end
end
