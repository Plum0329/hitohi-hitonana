# frozen_string_literal: true

module Admin
  module ContactsHelper
    def status_badge_class(status)
      case status
      when 'pending'
        'bg-warning text-dark'
      when 'in_progress'
        'bg-info text-dark'
      when 'completed'
        'bg-success'
      end
    end
  end
end
