class AddImagePostRefToPosts < ActiveRecord::Migration[7.0]
  def change
    add_reference :posts, :image_post, null: true, foreign_key: true
  end
end
