class ThemeDeletionRequestsController < ApplicationController
  before_action :require_login
  before_action :set_theme, only: [:new, :confirm, :create]
  before_action :ensure_theme_owner, only: [:new, :confirm, :create]

  def new
    @theme_deletion_request = if params[:theme_deletion_request].present?
      ThemeDeletionRequest.new(theme_deletion_request_params.merge(theme: @theme))
    else
      ThemeDeletionRequest.new(theme: @theme)
    end
  end

  def confirm
    @theme_deletion_request = current_user.theme_deletion_requests.build(theme_deletion_request_params)
    @theme_deletion_request.theme = @theme

    unless @theme_deletion_request.valid?
      return render :new
    end

    render :confirm
  end

  def create
    @theme_deletion_request = current_user.theme_deletion_requests.build(theme_deletion_request_params)
    @theme_deletion_request.theme = @theme

    if params[:back].present?
      render :new
      return
    end

    if @theme_deletion_request.save
      redirect_to theme_deletion_request_path(@theme_deletion_request), notice: '削除申請を受け付けました'
    else
      render :new
    end
  end

  def show
    @theme_deletion_request = current_user.theme_deletion_requests.find(params[:id])
  end

  private

  def theme_deletion_request_params
    params.require(:theme_deletion_request).permit(:reason)
  rescue ActionController::ParameterMissing
    {}
  end

  def set_theme
    @theme = Theme.find(params[:theme_id])
  end

  def ensure_theme_owner
    unless @theme.user == current_user
      redirect_to root_path, alert: '権限がありません'
    end
  end
end