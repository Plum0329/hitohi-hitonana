# frozen_string_literal: true

module Admin
  class PostsReportsController < Admin::BaseController
    def index
      @posts_reports = PostsReport.includes(:user, :post).order(created_at: :desc).page(params[:page])
    end

    def show
      @posts_report = PostsReport.find(params[:id])
    end

    def approve
      @posts_report = PostsReport.find(params[:id])
      @posts_report.transaction do
        @posts_report.approved!
        @posts_report.post.soft_delete
      end
      redirect_to admin_posts_reports_path, notice: '報告を承認しました'
    end

    def reject
      @posts_report = PostsReport.find(params[:id])
      @posts_report.rejected!
      redirect_to admin_posts_reports_path, notice: '報告を却下しました'
    end
  end
end
