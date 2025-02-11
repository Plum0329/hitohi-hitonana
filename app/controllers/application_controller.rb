# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :require_login
  before_action :set_turbo_frame_request_variant

  private

  def not_authenticated
    flash[:alert] = 'ログインしてください'
    redirect_to login_path
  end

  def flash_success(message)
    flash.now[:success] = message
  end

  def flash_error(message)
    flash.now[:error] = message
  end

  def flash_notice(message)
    flash.now[:notice] = message
  end

  def set_turbo_frame_request_variant
    request.variant = :turbo_frame if turbo_frame_request?
  end
end
