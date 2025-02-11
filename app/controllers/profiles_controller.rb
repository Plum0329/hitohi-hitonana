# frozen_string_literal: true

class ProfilesController < ApplicationController
  before_action :require_login

  def show
    @user = current_user
    @posts = @user.posts.available.includes(:tags, :image_post).order(created_at: :desc)
    @liked_posts = Post.available
                       .joins(:likes)
                       .includes(:tags, :image_post)
                       .where(likes: { user_id: @user.id })
                       .order('likes.created_at DESC')
    @liked_themes = Theme.available
                         .joins(:likes)
                         .where(likes: { user_id: @user.id })
                         .order('likes.created_at DESC')
    @image_post = ImagePost.find_by(id: session[:image_post_id]) if session[:image_post_id]
    @show_like_button = false
  rescue StandardError => e
    logger.error "Error in profiles#show: #{e.message}"
    flash.now[:alert] = 'プロフィールの取得中にエラーが発生しました'
    @posts = Post.none
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
