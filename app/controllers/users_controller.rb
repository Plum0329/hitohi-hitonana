class UsersController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.available
              .includes(:tags, :image_post, theme: [:posts])
              .order(created_at: :desc)
              .limit(5)
    @themes = @user.themes.available
              .includes(:posts)
              .order(created_at: :desc)
              .limit(5)
  end

  def create
    @user = User.new(user_params)
    @user.role = :general

    if @user.save
      auto_login(@user)
      redirect_to root_path, success: t('.success')
    else
      flash.now[:error] = t('.fail')
      render :new, status: :unprocessable_entity
    end
  end

  def posts
    @user = User.find(params[:id])
    @posts = @user.posts.available
                  .includes(:tags, :image_post, theme: [:posts, { image_attachment: :blob }])
                  .order(created_at: :desc)
                  .page(params[:page])
  end

  def themes
    @user = User.find(params[:id])
    @themes = @user.themes.available
                  .order(created_at: :desc)
                  .page(params[:page])
  end

  def liked_posts
    @user = User.find(params[:id])
    @posts = Post.available
                .where(id: @user.likes.where(likeable_type: 'Post').select(:likeable_id))
                .includes(:tags, :image_post, theme: [:posts])
                .order(created_at: :desc)
                .page(params[:page])
    @show_like_button = true
  end

  def liked_themes
    @user = User.find(params[:id])
    @themes = Theme.available
                  .where(id: @user.likes.where(likeable_type: 'Theme').select(:likeable_id))
                  .includes(:posts)
                  .order(created_at: :desc)
                  .page(params[:page])
    @show_like_button = true
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :name)
  end
end