class Admin::PostsController < Admin::BaseController
  def index
    @posts = Post.includes(:user).order(created_at: :desc).page(params[:page])
  end
end