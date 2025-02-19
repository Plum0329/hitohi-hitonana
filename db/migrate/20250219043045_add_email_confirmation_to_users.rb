class AddEmailConfirmationToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :email_confirmed, :boolean, default: false
    add_column :users, :confirmation_token, :string
    add_column :users, :confirmation_sent_at, :datetime

    add_index :users, :confirmation_token, unique: true
  end
end
