class AddLastGeneralPostAtToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :last_general_post_at, :datetime
    add_index :users, :last_general_post_at
  end
end
