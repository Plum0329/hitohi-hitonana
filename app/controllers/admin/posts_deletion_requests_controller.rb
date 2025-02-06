class Admin::PostsDeletionRequestsController < Admin::BaseController
  def index
    @posts_deletion_requests = PostsDeletionRequest.includes(:user, :post).order(created_at: :desc).page(params[:page])
  end

  def show
    @posts_deletion_request = PostsDeletionRequest.find(params[:id])
  end

  def approve
    @posts_deletion_request = PostsDeletionRequest.find(params[:id])
    @posts_deletion_request.transaction do
      @posts_deletion_request.approved!
      @posts_deletion_request.post.soft_delete
    end
    redirect_to admin_posts_deletion_requests_path, notice: '削除申請を承認しました'
  end

  def reject
    @posts_deletion_request = PostsDeletionRequest.find(params[:id])
    @posts_deletion_request.rejected!
    redirect_to admin_posts_deletion_requests_path, notice: '削除申請を却下しました'
  end
end