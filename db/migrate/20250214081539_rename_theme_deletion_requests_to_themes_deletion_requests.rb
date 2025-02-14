class RenameThemeDeletionRequestsToThemesDeletionRequests < ActiveRecord::Migration[7.0]
  def change
    rename_table :theme_deletion_requests, :themes_deletion_requests
  end
end
