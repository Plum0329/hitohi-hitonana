# frozen_string_literal: true

module Admin
  module ApplicationHelper
    def active_admin_link?(controller_name)
      params[:controller].end_with?(controller_name)
    end
  end
end
