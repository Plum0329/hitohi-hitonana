module Admin::PostsDeletionRequestsHelper
  def status_color_class(status)
    case status
    when 'pending'
      'warning'
    when 'approved'
      'success'
    when 'rejected'
      'danger'
    end
  end
end