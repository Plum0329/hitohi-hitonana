class RenameContentInPosts < ActiveRecord::Migration[7.0]
  def change
    rename_column :posts, :content, :display_content
  end
end
