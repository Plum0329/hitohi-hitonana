# frozen_string_literal: true

class ThemesReportsController < ApplicationController
  before_action :require_login
  before_action :set_theme, only: %i[new confirm create]
  before_action :ensure_not_theme_owner, only: %i[new confirm create]

  def show
    @themes_report = current_user.themes_reports.find(params[:id])
  end

  def new
    @themes_report = if params[:themes_report].present?
                       ThemesReport.new(themes_report_params.merge(theme: @theme))
                     else
                       ThemesReport.new(theme: @theme)
                     end
  end

  def confirm
    @themes_report = current_user.themes_reports.build(themes_report_params)
    @themes_report.theme = @theme

    return render :new unless @themes_report.valid?

    render :confirm
  end

  def create
    @themes_report = current_user.themes_reports.build(themes_report_params)
    @themes_report.theme = @theme

    if params[:back].present?
      render :new
      return
    end

    if @themes_report.save
      redirect_to themes_report_path(@themes_report), notice: '報告を受け付けました'
    else
      render :new
    end
  end

  private

  def themes_report_params
    params.require(:themes_report).permit(:reason_category, :reason)
  rescue ActionController::ParameterMissing
    {}
  end

  def set_theme
    @theme = Theme.find(params[:theme_id])
  end

  def ensure_not_theme_owner
    return unless @theme.user == current_user

    redirect_to root_path, alert: '自分のお題は報告できません'
  end
end
