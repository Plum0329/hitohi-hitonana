class Admin::UserSessionsController < Admin::BaseController
  skip_before_action :require_login, only: %i[new create]
  skip_before_action :check_admin, only: %i[new create]
  layout 'admin/login'

  def new; end

  def create
    @user = login(params[:email], params[:password])
    if @user&.admin?
      @user.update(last_login_at: Time.current)  # ログイン時刻を更新
      redirect_to admin_root_path, success: 'ログインしました'
    else
      flash.now[:danger] = 'ログインに失敗しました'
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    logout
    redirect_to admin_login_path, status: :see_other, success: 'ログアウトしました'
  end
end