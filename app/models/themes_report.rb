class ThemesReport < ApplicationRecord
  include Reportable
  belongs_to :user
  belongs_to :theme

  validate :cannot_report_own_theme, on: :create
  validate :no_duplicate_reports, on: :create

  private

  def cannot_report_own_theme
    if user_id == theme.user_id
      errors.add(:base, '自分のお題は報告できません')
    end
  end

  def no_duplicate_reports
    if ThemesReport.exists?(theme_id: theme_id, user_id: user_id, status: :pending)
      errors.add(:base, 'すでにこの投稿を報告しています')
    end
  end
end