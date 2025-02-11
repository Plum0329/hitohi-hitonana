# frozen_string_literal: true

module Admin
  class BaseController < ApplicationController
    include Sortable

    before_action :require_login
    before_action :check_admin
    layout 'admin/application'

    private

    def check_admin
      return if current_user&.admin?

      flash[:error] = '管理者権限が必要です'
      redirect_to root_path
    end

    def not_authenticated
      flash[:warning] = 'ログインしてください'
      redirect_to admin_login_path
    end
  end
end
