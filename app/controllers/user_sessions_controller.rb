class UserSessionsController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]

  def new
    @user = User.new
  end

  def create
    @user = User.find_by(email: params[:email])

    if @user.nil?
      flash.now[:error] = "メールアドレスまたはパスワードが間違っています"
      flash.now[:notice] = "アカウントをお持ちでない方は#{view_context.link_to('新規登録', signup_path)}を行ってください"
      render :new, status: :unprocessable_entity
      return
    end

    if @user.inactive?
      flash.now[:error] = t('.account_inactive')
      render :new, status: :unprocessable_entity
      return
    end

    if login(params[:email], params[:password])
      redirect_back_or_to root_path, success: t('.success')
    else
      flash.now[:error] = t('.invalid_login')
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    logout
    redirect_to root_path, success: t('.success')
  end
end