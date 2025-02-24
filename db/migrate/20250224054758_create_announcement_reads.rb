class CreateAnnouncementReads < ActiveRecord::Migration[7.0]
  def change
    create_table :announcement_reads do |t|
      t.references :announcement, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    add_index :announcement_reads, [:announcement_id, :user_id], unique: true
  end
end