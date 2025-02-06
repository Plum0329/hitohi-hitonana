class AddDeletedRequestsToPosts < ActiveRecord::Migration[7.0]
  def change
    add_reference :deletion_requests, :post, foreign_key: true, null: false unless column_exists?(:deletion_requests, :post_id)
  end
end
