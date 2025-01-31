module ApplicationHelper
  def back_button(fallback_path = nil)
    fallback_path ||= root_path
    render 'shared/back_button', fallback_path: fallback_path
  end

  def with_turbo_frame_reload(&block)
    turbo_frame_tag "_top" do
      capture(&block)
    end
  end

  def page_title(title = '', admin: false)
    base_title = admin ? 'HITOHI-HITONANA(管理画面)' : 'HITOHI-HITONANA'
    title.present? ? "#{title} | #{base_title}" : base_title
  end

  def flash_class(key)
    case key
    when 'success'
      'bg-green-100 border border-green-400 text-green-700'
    when 'danger'
      'bg-red-100 border border-red-400 text-red-700'
    when 'warning'
      'bg-yellow-100 border border-yellow-400 text-yellow-700'
    when 'info'
      'bg-blue-100 border border-blue-400 text-blue-700'
    else
      'bg-gray-100 border border-gray-400 text-gray-700'
    end
  end
end