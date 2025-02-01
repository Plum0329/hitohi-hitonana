class Admin::UsersController < Admin::BaseController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :deactivate, :activate]

  def index
    @users = User.order(created_at: :desc).page(params[:page]).per(20)
  end

  def show
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to admin_user_path(@user), success: t('.success')
    else
      flash.now[:error] = t('.fail')
      render :edit
    end
  end

  def deactivate
    if @user.deactivate
      redirect_to admin_users_path, success: "アカウントを無効化しました"
    else
      redirect_to admin_users_path, error: "アカウントの無効化に失敗しました"
    end
  end

  def activate
    if @user.activate
      redirect_to admin_users_path, success: "アカウントを有効化しました"
    else
      redirect_to admin_users_path, error: "アカウントの有効化に失敗しました"
    end
  end

  def destroy
    if @user.destroy
      redirect_to admin_users_path, success: "ユーザーを完全に削除しました"
    else
      redirect_to admin_users_path, error: "ユーザーの削除に失敗しました"
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :role)
  end
end