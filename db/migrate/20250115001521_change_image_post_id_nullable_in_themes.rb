class ChangeImagePostIdNullableInThemes < ActiveRecord::Migration[7.0]
  def change
    change_column_null :themes, :image_post_id, true
  end
end
