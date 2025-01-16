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
end