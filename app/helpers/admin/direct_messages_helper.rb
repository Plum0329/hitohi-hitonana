# frozen_string_literal: true

module Admin
  module DirectMessagesHelper
    def direct_message_status_color(direct_message)
      case direct_message.status
      when 'draft' then 'secondary'
      when 'published' then 'success'
      when 'archived' then 'dark'
      end
    end

    def direct_message_priority_color(direct_message)
      case direct_message.priority
      when 'normal' then 'info'
      when 'important' then 'warning'
      when 'urgent' then 'danger'
      end
    end
  end
end
