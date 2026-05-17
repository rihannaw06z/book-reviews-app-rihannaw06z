class Review < ApplicationRecord
  belongs_to :user

  has_many :likes, dependent: :destroy
  
  validates :google_book_id, presence: true
  validates :rating, presence: true, numericality: { less_than_or_equal_to: 5 }
  validates :comment, length: { maximum: 500 }
  validates :title, presence: true

  def book_details
    url = "https://www.googleapis.com/books/v1/volumes/#{google_book_id}?key=#{ENV['GOOGLE_BOOKS_KEY']}&country=US"
    response = HTTParty.get(url, verify: false)
    JSON.parse(response.body.force_encoding("UTF-8")) if response.code == 200
  end
end
