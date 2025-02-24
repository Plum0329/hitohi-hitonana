# frozen_string_literal: true

module Admin
  module AnnouncementsHelper
    def announcement_status_color(announcement)
      case announcement.status
      when 'draft' then 'secondary'
      when 'published' then 'success'
      when 'archived' then 'dark'
      end
    end

    def announcement_priority_color(announcement)
      case announcement.priority
      when 'normal' then 'info'
      when 'important' then 'warning'
      when 'urgent' then 'danger'
      end
    end
  end
end
