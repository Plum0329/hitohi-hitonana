class AddImagePostRefToThemes < ActiveRecord::Migration[7.0]
  def change
    add_reference :themes, :image_post, null: false, foreign_key: true
  end
end
