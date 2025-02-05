class CreateContacts < ActiveRecord::Migration[7.0]
  def change
    create_table :contacts do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.text :content, null: false
      t.string :category, null: false
      t.string :status, null: false, default: 'pending'
      t.text :admin_memo
      t.boolean :privacy_policy_agreed, null: false, default: false
      t.datetime :responded_at

      t.timestamps
    end

    add_index :contacts, :status
    add_index :contacts, :category
    add_index :contacts, :created_at
  end
end