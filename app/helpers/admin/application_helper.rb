module Admin::ApplicationHelper
  def active_admin_link?(controller_name)
    params[:controller].end_with?(controller_name)
  end
end