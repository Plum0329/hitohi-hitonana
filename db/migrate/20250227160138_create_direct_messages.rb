class CreateDirectMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :direct_messages do |t|
      t.string :title, null: false
      t.text :content, null: false
      t.integer :status, null: false, default: 0
      t.integer :priority, null: false, default: 0
      t.datetime :published_at
      t.references :admin, null: false, foreign_key: { to_table: :users }
      t.references :recipient, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end