class Admin::ThemeDeletionRequestsController < Admin::BaseController
  def index
    @theme_deletion_requests = ThemeDeletionRequest.includes(:user, :theme).order(created_at: :desc).page(params[:page])
  end

  def show
    @theme_deletion_request = ThemeDeletionRequest.find(params[:id])
  end

  def approve
    @theme_deletion_request = ThemeDeletionRequest.find(params[:id])
    @theme_deletion_request.transaction do
      @theme_deletion_request.approved!
      @theme_deletion_request.theme.soft_delete
    end
    redirect_to admin_theme_deletion_requests_path, notice: '削除申請を承認しました'
  end

  def reject
    @theme_deletion_request = ThemeDeletionRequest.find(params[:id])
    @theme_deletion_request.rejected!
    redirect_to admin_theme_deletion_requests_path, notice: '削除申請を却下しました'
  end
end