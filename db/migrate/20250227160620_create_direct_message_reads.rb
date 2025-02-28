class CreateDirectMessageReads < ActiveRecord::Migration[7.0]
  def change
    create_table :direct_message_reads do |t|
      t.references :direct_message, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    add_index :direct_message_reads, [:direct_message_id, :user_id], unique: true
  end
end