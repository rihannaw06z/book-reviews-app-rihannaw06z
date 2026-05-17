class AddUserToReviews < ActiveRecord::Migration[8.1]
  def up
    add_reference :reviews, :user, foreign_key: true, null: true

    fallback_user = User.first || User.create!(
      email_address: "fallback@example.com",
      username: "flutter_archive",
      password: "SecurePassword123!"
    )

    Review.where(user_id: nil).update_all(user_id: fallback_user.id)
    change_column_null :reviews, :user_id, false
  end

  def down
    remove_reference :reviews, :user
  end
end
