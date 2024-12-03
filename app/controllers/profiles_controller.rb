class ProfilesController < ApplicationController
  before_action :require_login
  
  def show
    @user = current_user
    @posts = @user.posts.order(created_at: :desc)
  end
  
  def edit
    @user = current_user
  end
  
  def update
    @user = current_user
    if @user.update(user_params)
      redirect_to profile_path, notice: 'プロフィールを更新しました'
    else
      render :edit, status: :unprocessable_entity
    end
  end
  
  def edit_password
    @user = current_user
  end
  
  def update_password
    @user = current_user
    if @user.update(password_params)
      redirect_to profile_path, notice: 'パスワードを更新しました'
    else
      render :edit_password, status: :unprocessable_entity
    end
  end
  
  private
  
  def user_params
    params.require(:user).permit(:email, :name)
  end
  
  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end