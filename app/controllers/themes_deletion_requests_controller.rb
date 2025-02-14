# frozen_string_literal: true

class ThemesDeletionRequestsController < ApplicationController
  before_action :require_login
  before_action :set_theme, only: %i[new confirm create]
  before_action :ensure_theme_owner, only: %i[new confirm create]

  def show
    @themes_deletion_request = current_user.themes_deletion_requests.find(params[:id])
  end

  def new
    @themes_deletion_request = if params[:themes_deletion_request].present?
                                 ThemesDeletionRequest.new(themes_deletion_request_params.merge(theme: @theme))
                               else
                                 ThemesDeletionRequest.new(theme: @theme)
                               end
  end

  def confirm
    @themes_deletion_request = current_user.themes_deletion_requests.build(themes_deletion_request_params)
    @themes_deletion_request.theme = @theme

    return render :new unless @themes_deletion_request.valid?

    render :confirm
  end

  def create
    @themes_deletion_request = current_user.themes_deletion_requests.build(themes_deletion_request_params)
    @themes_deletion_request.theme = @theme

    if params[:back].present?
      render :new
      return
    end

    if @themes_deletion_request.save
      redirect_to themes_deletion_request_path(@themes_deletion_request), notice: '削除申請を受け付けました'
    else
      render :new
    end
  end

  private

  def themes_deletion_request_params
    params.require(:themes_deletion_request).permit(:reason)
  rescue ActionController::ParameterMissing
    {}
  end

  def set_theme
    @theme = Theme.find(params[:theme_id])
  end

  def ensure_theme_owner
    return if @theme.user == current_user

    redirect_to root_path, alert: '権限がありません'
  end
end
