class CreateBooks < ActiveRecord::Migration[8.1]
  def change
    create_table :books do |t|
      t.string :google_book_id
      t.string :title
      t.string :authors
      t.string :publisher
      t.string :published_date
      t.string :categories

      t.timestamps
    end
  end
end
