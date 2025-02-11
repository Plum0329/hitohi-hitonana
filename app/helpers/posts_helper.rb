# frozen_string_literal: true

module PostsHelper
  def first_post?(post)
    post.theme.present? &&
      post == post.theme.posts.order(created_at: :asc).first
  end
end
