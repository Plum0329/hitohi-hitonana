class AddIndicesForLikes < ActiveRecord::Migration[7.0]
  def change
    add_index :likes, [:user_id, :likeable_type]
    add_index :likes, [:likeable_type, :likeable_id]
  end
end
