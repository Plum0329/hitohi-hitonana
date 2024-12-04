class RegistrationsController < ApplicationController
  before_action :require_login

  def deactivate
    if current_user.soft_delete
      logout
      redirect_to root_path, notice: 'アカウントを削除しました'
    else
      redirect_to profile_path, alert: 'アカウントの削除に失敗しました'
    end
  end
end