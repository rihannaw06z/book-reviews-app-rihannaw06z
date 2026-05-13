class RemoveBookReferenceFromReviews < ActiveRecord::Migration[8.1]
  def change
    remove_reference :reviews, :book, null: false, foreign_key: true
  end
end
