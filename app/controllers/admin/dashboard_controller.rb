# frozen_string_literal: true

module Admin
  class DashboardController < Admin::BaseController
    def index
      @stats = {
        total_users: User.count,
        total_posts: Post.count,
        today_posts: Post.where(created_at: Time.current.beginning_of_day..).count,
        active_users: User.where(last_login_at: 30.days.ago..).count
      }

      @recent_users = User.order(created_at: :desc).limit(5)
      @recent_posts = Post.order(created_at: :desc).limit(5)
    end
  end
end
