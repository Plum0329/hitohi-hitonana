class UsersController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to root_path, notice: 'ユーザー登録が完了しました'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def posts
    @user = User.find(params[:id])
    @posts = @user.posts.order(created_at: :desc).page(params[:page])
  end

  def themes
    @user = User.find(params[:id])
    @themes = @user.themes.order(created_at: :desc).page(params[:page])
    render template: 'themes/index'
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :name)
  end
end