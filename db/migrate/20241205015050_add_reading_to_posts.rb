class AddReadingToPosts < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :reading, :string, null: false
  end
end
