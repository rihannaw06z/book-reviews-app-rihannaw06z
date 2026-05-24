class AddLikesCountToReviews < ActiveRecord::Migration[8.1]
  def change
    add_column :reviews, :likes_count, :integer
  end
end
