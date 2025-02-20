class AddReplyFieldsToContacts < ActiveRecord::Migration[7.0]
  def change
    add_column :contacts, :reply_content, :text
    add_column :contacts, :replied_at, :datetime
  end
end
