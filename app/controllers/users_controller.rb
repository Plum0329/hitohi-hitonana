class UsersController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]

  def new
    @user = User.new
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
    @posts = @user.posts
                .includes(:tags, :image_post, theme: [:posts, { image_attachment: :blob }])
                .order(created_at: :desc)
                .page(params[:page])
  end

  def themes
    @user = User.find(params[:id])
    @themes = @user.themes.order(created_at: :desc).page(params[:page])
  end

  def liked_posts
    @user = User.find(params[:id])
    @posts = @user.likes.where(likeable_type: 'Post')
                      .includes(likeable: [:tags, :image_post, theme: [:posts]])
                      .order(created_at: :desc)
                      .map(&:likeable)
    @show_like_button = true
  end

  def liked_themes
    @user = User.find(params[:id])
    @themes = @user.likes.where(likeable_type: 'Theme')
                      .includes(:likeable)
                      .order(created_at: :desc)
                      .map(&:likeable)
    @show_like_button = true
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :name)
  end
end