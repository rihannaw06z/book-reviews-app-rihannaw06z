class AddBookReferenceToReviews < ActiveRecord::Migration[8.1]
  def change
    add_reference :reviews, :book, null: false, foreign_key: true
  end
end
