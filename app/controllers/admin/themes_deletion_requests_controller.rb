# frozen_string_literal: true

module Admin
  class ThemesDeletionRequestsController < Admin::BaseController
    def index
      @themes_deletion_requests = ThemesDeletionRequest.includes(:user,
                                                                 :theme).order(created_at: :desc).page(params[:page])
    end

    def show
      @themes_deletion_request = ThemesDeletionRequest.find(params[:id])
    end

    def approve
      @themes_deletion_request = ThemesDeletionRequest.find(params[:id])
      @themes_deletion_request.transaction do
        @themes_deletion_request.approved!
        @themes_deletion_request.theme.soft_delete
      end
      redirect_to admin_themes_deletion_requests_path, notice: '削除申請を承認しました'
    end

    def reject
      @themes_deletion_request = ThemesDeletionRequest.find(params[:id])
      @themes_deletion_request.rejected!
      redirect_to admin_themes_deletion_requests_path, notice: '削除申請を却下しました'
    end
  end
end
