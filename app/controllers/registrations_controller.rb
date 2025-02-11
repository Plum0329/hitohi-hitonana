# frozen_string_literal: true

class RegistrationsController < ApplicationController
  before_action :require_login

  def deactivate
    current_user.deactivate
    logout
    redirect_to root_path, success: '退会処理が完了しました'
  end
end
