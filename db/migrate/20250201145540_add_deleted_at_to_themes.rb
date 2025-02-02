class AddDeletedAtToThemes < ActiveRecord::Migration[7.0]
  def change
    add_column :themes, :deleted_at, :datetime
  end
end
