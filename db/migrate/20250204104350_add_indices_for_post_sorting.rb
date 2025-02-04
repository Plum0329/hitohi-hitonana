class AddIndicesForPostSorting < ActiveRecord::Migration[7.0]
  def change
    add_index :posts, :created_at
    add_index :likes, [:likeable_id, :likeable_type, :created_at], name: 'index_likes_on_likeable_and_created_at'
  end
end
