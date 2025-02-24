# frozen_string_literal: true

class AnnouncementsController < ApplicationController
  def index
    @announcements = Announcement.active.recent.page(params[:page])
  end

  def show
    @announcement = Announcement.active.find(params[:id])
    mark_as_read if logged_in?
  end

  private

  def mark_as_read
    current_user.announcement_reads.find_or_create_by(announcement: @announcement)
  end
end
