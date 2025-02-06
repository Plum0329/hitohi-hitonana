class RenameDeletionRequestsToPostsDeletionRequests < ActiveRecord::Migration[7.0]
  def change
    rename_table :deletion_requests, :posts_deletion_requests
  end
end