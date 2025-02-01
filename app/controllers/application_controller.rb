class ApplicationController < ActionController::Base
  before_action :require_login

  private

  def not_authenticated
    flash[:alert] = 'ログインしてください'
    redirect_to login_path
  end

  def flash_success(message)
    flash[:success] = message
  end

  def flash_error(message)
    flash[:error] = message
  end

  def flash_notice(message)
    flash[:notice] = message
  end
end