# frozen_string_literal: true

class UsersController < ApplicationController
  skip_before_action :require_login, only: %i[new create]

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

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.role = :general

    if @user.save
      auto_login(@user)
      UserMailer.with(user: @user).confirmation_email.deliver_later
      redirect_to root_path, success: t('.success')
    else
      flash.now[:error] = t('.fail')
      render :new, status: :unprocessable_entity
    end
  end

  def confirm_email
    user = User.find_by(confirmation_token: params[:confirmation_token])

    if user && user.confirmation_sent_at > 24.hours.ago
      user.confirm_email
      redirect_to root_path, notice: 'メールアドレスが確認されました'
    else
      redirect_to root_path, alert: '無効なトークンです'
    end
  end

  def resend_confirmation
    if current_user && !current_user.email_confirmed?
      current_user.generate_confirmation_token
      current_user.save
      UserMailer.with(user: current_user).confirmation_email.deliver_later
      redirect_to root_path, notice: '確認メールを再送信しました'
    else
      redirect_to root_path, alert: '確認メールの再送信に失敗しました'
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
