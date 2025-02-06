class Admin::DeletionRequestsController < Admin::BaseController
  def index
    @deletion_requests = DeletionRequest.includes(:user, :post).order(created_at: :desc).page(params[:page])
  end

  def show
    @deletion_request = DeletionRequest.find(params[:id])
  end

  def approve
    @deletion_request = DeletionRequest.find(params[:id])
    @deletion_request.transaction do
      @deletion_request.approved!
      @deletion_request.post.soft_delete
    end
    redirect_to admin_deletion_requests_path, notice: '削除申請を承認しました'
  end

  def reject
    @deletion_request = DeletionRequest.find(params[:id])
    @deletion_request.rejected!
    redirect_to admin_deletion_requests_path, notice: '削除申請を却下しました'
  end
end