class AddStatusToThemes < ActiveRecord::Migration[7.0]
  def change
    add_column :themes, :status, :integer, default: 0
    add_index :themes, :status
  end
end
