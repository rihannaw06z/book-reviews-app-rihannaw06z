class BooksByController < ApplicationController
  allow_unauthenticated_access only: [:index]
  def index
    @query = params[:author]
    if @query.present?                              #allows users to search for books by author name, and list results by relevance.
      key= ENV["GOOGLE_BOOKS_KEY"]
      q= "inauthor:#{CGI.escape(@query)}"
      url = "https://www.googleapis.com/books/v1/volumes?q=#{q}&orderBy=relevance&key=#{key}&country=US" 

      response = HTTParty.get(url, verify: false)
      parsed = JSON.parse(response.body.force_encoding("UTF-8"))
      
      @books_by_author = parsed["items"] || []
    else
      @books_by_author = []
    end
  rescue JSON::ParserError => e                                #handles potential JSON parsing errors gracefully, logging the error and providing user feedback without crashing the application.
    Rails.logger.error("JSON parse failed: #{e.message}")
    @books_by_author = []
    flash[:alert] = "There was a problem fetching results from Google Books."
  end
end
