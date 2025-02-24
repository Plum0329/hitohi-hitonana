# frozen_string_literal: true

module Admin
  class AnnouncementsController < Admin::BaseController
    def index
      @announcements = Announcement.recent.page(params[:page])
    end

    def new
      @announcement = Announcement.new
    end

    def edit
      @announcement = Announcement.find(params[:id])
    end

    def create
      @announcement = Announcement.new(announcement_params)
      @announcement.admin = current_user

      if @announcement.save
        redirect_to admin_announcements_path, success: t('.success')
      else
        render :new
      end
    end

    def update
      @announcement = Announcement.find(params[:id])
      if @announcement.update(announcement_params)
        redirect_to admin_announcements_path, success: t('.success')
      else
        render :edit
      end
    end

    def publish
      @announcement = Announcement.find(params[:id])
      if @announcement.update(status: :published, published_at: Time.current)
        redirect_to admin_announcements_path, success: t('.success')
      else
        redirect_to admin_announcements_path, error: t('.failure')
      end
    end

    def archive
      @announcement = Announcement.find(params[:id])
      if @announcement.update(status: :archived)
        redirect_to admin_announcements_path, success: t('.success')
      else
        redirect_to admin_announcements_path, error: t('.failure')
      end
    end

    private

    def announcement_params
      params.require(:announcement).permit(:title, :content, :status, :priority, :published_at)
    end
  end
end
