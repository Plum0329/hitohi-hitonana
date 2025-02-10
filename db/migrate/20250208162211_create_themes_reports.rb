class CreateThemesReports < ActiveRecord::Migration[7.0]
  def change
    create_table :themes_reports do |t|
      t.references :user, null: false, foreign_key: true
      t.references :theme, null: false, foreign_key: true
      t.string :reason_category, null: false
      t.text :reason, null: false
      t.integer :status, default: 0
      t.text :admin_note
      t.timestamps
    end
  end
end
