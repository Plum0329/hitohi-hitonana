class AddIndicesForThemeSorting < ActiveRecord::Migration[7.0]
  def change
    add_index :themes, :created_at
    add_column :themes, :posts_count, :integer, default: 0
    add_index :themes, :posts_count
  end
end
