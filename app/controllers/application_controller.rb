class ApplicationController < ActionController::Base
before_action :require_login

  private

  def not_authenticated
    unless logged_in?
      redirect_to login_path, alert: 'ログインしてください'
    end
  end
end
