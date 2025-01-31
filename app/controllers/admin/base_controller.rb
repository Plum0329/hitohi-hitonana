class Admin::BaseController < ApplicationController
  before_action :require_login
  before_action :check_admin
  layout 'admin/application'

  private

  def check_admin
    unless current_user&.admin?
      redirect_to root_path, alert: '管理者権限が必要です'
    end
  end

  def not_authenticated
    flash[:warning] = 'ログインしてください'
    redirect_to admin_login_path
  end
end