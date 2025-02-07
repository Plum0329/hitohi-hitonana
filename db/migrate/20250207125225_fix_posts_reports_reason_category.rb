class FixPostsReportsReasonCategory < ActiveRecord::Migration[7.0]
  def up
    change_column :posts_reports, :reason_category, :integer, using: 'reason_category::integer'

    change_column_default :posts_reports, :reason_category, 4
  end

  def down
    change_column :posts_reports, :reason_category, :string
    change_column_default :posts_reports, :reason_category, nil
  end
end
