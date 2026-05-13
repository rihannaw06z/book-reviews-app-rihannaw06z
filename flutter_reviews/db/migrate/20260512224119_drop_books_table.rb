class DropBooksTable < ActiveRecord::Migration[8.1]
  def change
    drop_table :books
  end
end
