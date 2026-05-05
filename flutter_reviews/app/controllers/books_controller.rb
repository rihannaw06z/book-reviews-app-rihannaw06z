class BooksController < ApplicationController
  def index
    @query = params[:query]
    if @query.present?
      key = ENV["GOOGLE_BOOKS_KEY"]
      q = CGI.escape(@query)
      url = "https://www.googleapis.com/books/v1/volumes?q=#{q}&key=#{key}"

      Rails.logger.info("Google Books URL: #{url}")

      response = HTTParty.get(url, verify: false)
      parsed = JSON.parse(response.body.force_encoding("UTF-8"))
      
      if parsed["error"]
        Rails.logger.error("Google Books API error: #{parsed['error']['message']}")
        @books = parsed["items"] || []
        flash[:alert] = "Google Books API error: #{parsed['error']['message']}"
      else
        @books = parsed["items"] || []
      end
    else
      @books = []
    end
  rescue JSON::ParserError => e
    Rails.logger.error("JSON parse failed: #{e.message}")
    @books = []
    flash[:alert] = "There was a problem fetching results from Google Books."
  end
end
