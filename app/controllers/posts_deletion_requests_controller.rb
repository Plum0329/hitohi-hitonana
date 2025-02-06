class PostsDeletionRequestsController < ApplicationController
  before_action :require_login
  before_action :set_post, only: [:new, :confirm, :create]
  before_action :ensure_post_owner, only: [:new, :confirm, :create]

  def new
    @posts_deletion_request = if params[:posts_deletion_request].present?
      PostsDeletionRequest.new(posts_deletion_request_params.merge(post: @post))
    else
      PostsDeletionRequest.new(post: @post)
    end
  end

  def confirm
    @posts_deletion_request = current_user.posts_deletion_requests.build(posts_deletion_request_params)
    @posts_deletion_request.post = @post

    unless @posts_deletion_request.valid?
      return render :new
    end

    render :confirm
  end

  def create
    @posts_deletion_request = current_user.posts_deletion_requests.build(posts_deletion_request_params)
    @posts_deletion_request.post = @post

    if params[:back].present?
      render :new
      return
    end

    if @posts_deletion_request.save
      redirect_to posts_deletion_request_path(@posts_deletion_request), notice: '削除申請を受け付けました'
    else
      render :new
    end
  end

  def show
    @posts_deletion_request = current_user.posts_deletion_requests.find(params[:id])
  end

  private

  def posts_deletion_request_params
    params.require(:posts_deletion_request).permit(:reason)
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