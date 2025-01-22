class AddDefaultToLikesCount < ActiveRecord::Migration[7.0]
  def up
    change_column_default :posts, :likes_count, from: nil, to: 0
    change_column_default :themes, :likes_count, from: nil, to: 0

    # 既存のレコードのlikes_countがnilの場合は0に更新
    execute <<-SQL
      UPDATE posts SET likes_count = 0 WHERE likes_count IS NULL;
      UPDATE themes SET likes_count = 0 WHERE likes_count IS NULL;
    SQL
  end

  def down
    change_column_default :posts, :likes_count, from: 0, to: nil
    change_column_default :themes, :likes_count, from: 0, to: nil
  end
end