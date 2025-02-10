class FixThemesReportsReasonCategory < ActiveRecord::Migration[7.0]
  def up
    change_column :themes_reports, :reason_category, :integer, using: 'reason_category::integer'

    change_column_default :themes_reports, :reason_category, 4
  end

  def down
    change_column :themes_reports, :reason_category, :string
    change_column_default :themes_reports, :reason_category, nil
  end
end
