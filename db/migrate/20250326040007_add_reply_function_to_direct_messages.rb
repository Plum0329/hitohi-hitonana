class AddReplyFunctionToDirectMessages < ActiveRecord::Migration[7.0]
  def change
    add_column :direct_messages, :parent_id, :integer, null: true
    add_column :direct_messages, :allow_reply, :boolean, null: false, default: false
    add_index :direct_messages, :parent_id
    add_foreign_key :direct_messages, :direct_messages, column: :parent_id
  end
end
