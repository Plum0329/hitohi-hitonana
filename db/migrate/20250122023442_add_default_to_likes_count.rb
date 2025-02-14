class AddDefaultToLikesCount < ActiveRecord::Migration[7.0]
  def up
    add_column :posts, :likes_count, :integer, default: 0, null: false unless column_exists?(:posts, :likes_count)
    add_column :themes, :likes_count, :integer, default: 0, null: false unless column_exists?(:themes, :likes_count)

    execute <<-SQL
      UPDATE posts SET likes_count = 0 WHERE likes_count IS NULL;
      UPDATE themes SET likes_count = 0 WHERE likes_count IS NULL;
    SQL
  end

  def down
    remove_column :posts, :likes_count
    remove_column :themes, :likes_count
  end
end