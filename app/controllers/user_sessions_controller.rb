class UserSessionsController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]

  def new; end

  def create
    # emailでユーザーを検索
    user = User.find_by(email: params[:email])

    # ユーザーが見つかり、かつ退会済みの場合
    if user&.deleted?
      flash.now[:alert] = 'このアカウントは削除されています'
      render :new, status: :unauthorized
      return
    end

    # 通常のログイン処理
    @user = login(params[:email], params[:password])

    if @user
      redirect_back_or_to root_path, notice: t('flash.success.login')
    else
      flash.now[:alert] = t('flash.error.login')
      render :new, status: :unauthorized
    end
  end

  def destroy
    logout
    redirect_to root_path, notice: t('flash.success.logout')
  end
end