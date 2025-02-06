class DeletionRequestsController < ApplicationController
  before_action :require_login
  before_action :set_post, only: [:new, :confirm, :create]
  before_action :ensure_post_owner, only: [:new, :confirm, :create]

  def new
    @deletion_request = if params[:deletion_request].present?
      DeletionRequest.new(deletion_request_params.merge(post: @post))
    else
      DeletionRequest.new(post: @post)
    end
  end

  def confirm
    @deletion_request = current_user.deletion_requests.build(deletion_request_params)
    @deletion_request.post = @post

    unless @deletion_request.valid?
      return render :new
    end

    render :confirm
  end

  def create
    @deletion_request = current_user.deletion_requests.build(deletion_request_params)
    @deletion_request.post = @post

    if params[:back].present?
      render :new
      return
    end

    if @deletion_request.save
      redirect_to deletion_request_path(@deletion_request), notice: '削除申請を受け付けました'
    else
      render :new
    end
  end

  def show
    @deletion_request = current_user.deletion_requests.find(params[:id])
  end

  private

  def deletion_request_params
    params.require(:deletion_request).permit(:reason)
  rescue ActionController::ParameterMissing
    {}
  end

  def set_post
    @post = Post.find(params[:post_id])
  end

  def ensure_post_owner
    unless @post.user == current_user
      redirect_to root_path, alert: '権限がありません'
    end
  end
end