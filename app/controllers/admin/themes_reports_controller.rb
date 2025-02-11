# frozen_string_literal: true

module Admin
  class ThemesReportsController < Admin::BaseController
    def index
      @themes_reports = ThemesReport.includes(:user, :theme).order(created_at: :desc).page(params[:page])
    end

    def show
      @themes_report = ThemesReport.find(params[:id])
    end

    def approve
      @themes_report = ThemesReport.find(params[:id])
      @themes_report.transaction do
        @themes_report.approved!
        @themes_report.theme.soft_delete
      end
      redirect_to admin_themes_reports_path, notice: '報告を承認しました'
    end

    def reject
      @themes_report = ThemesReport.find(params[:id])
      @themes_report.rejected!
      redirect_to admin_themes_reports_path, notice: '報告を却下しました'
    end
  end
end
