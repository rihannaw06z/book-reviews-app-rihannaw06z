class BooksController < ApplicationController
  def index
    @query = params[:query]
    if @query.present?
      key = ENV["GOOGLE_BOOKS_KEY"]
      q = CGI.escape(@query)
      url = "https://www.googleapis.com/books/v1/volumes?q=#{q}&key=#{key}&country=US"

      response = HTTParty.get(url, verify: false)
      parsed = JSON.parse(response.body.force_encoding("UTF-8"))
      
      if parsed["error"]
        Rails.logger.error("Google Books API error: #{parsed['error']['message']}")
        @google_data = []
      else
        # Extract ISBN from the first result if available
        if parsed["items"].present?
          identifiers = parsed["items"].first["volumeInfo"]["industryIdentifiers"] || []
          isbn_entry = identifiers.find { |id| id["type"] == "ISBN_13" } || 
                        identifiers.find { |id| id["type"] == "ISBN_10" }
          
          if isbn_entry
            isbn_url = "https://www.googleapis.com/books/v1/volumes?q=isbn:#{isbn_entry['identifier']}&key=#{key}&country=US"
            isbn_response = HTTParty.get(isbn_url, verify: false)
            isbn_parsed = JSON.parse(isbn_response.body.force_encoding("UTF-8"))
            @google_data = isbn_parsed["items"] || []
          else
            @google_data = parsed["items"] || []
          end

          if @google_data.size <= 1
            author = parsed["items"].first["volumeInfo"]["authors"]&.first
            if author
              fallback_url = "https://www.googleapis.com/books/v1/volumes?q=inauthor:#{CGI.escape(author)}&key=#{key}&country=US"
              fallback_response = HTTParty.get(fallback_url, verify: false)
              fallback_parsed = JSON.parse(fallback_response.body.force_encoding("UTF-8"))
              @google_data = fallback_parsed["items"] || []
            end
          end
        else
          @google_data = []
        end
      end
    else
      @google_data = []
    end
  rescue JSON::ParserError => e
    Rails.logger.error("JSON parse failed: #{e.message}")
    @google_data = []
    flash[:alert] = "There was a problem fetching results from Google Books."
  end

  def show
    @google_data = fetch_single_book(params[:id])
    @reviews = Review.where(google_book_id: params[:id])
  end

  private
  def fetch_single_book(book_id)
    url = "https://www.googleapis.com/books/v1/volumes/#{book_id}?key=#{ENV['GOOGLE_BOOKS_KEY']}&country=US"
    response = HTTParty.get(url, verify: false)
    JSON.parse(response.body.force_encoding("UTF-8"))
  end
end
