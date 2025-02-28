# frozen_string_literal: true

class AnnouncementsController < ApplicationController
  def index
    @announcements = Announcement.active.recent

    if logged_in?
      @direct_messages = current_user.received_direct_messages
                                     .active
                                     .recent

      @notifications = (@announcements + @direct_messages)
                       .sort_by { |n| n.published_at || n.created_at }
                       .reverse
    else
      @notifications = @announcements
    end

    @notifications = Kaminari.paginate_array(@notifications).page(params[:page])
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
