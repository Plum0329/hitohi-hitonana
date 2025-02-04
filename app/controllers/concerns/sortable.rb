module Sortable
  extend ActiveSupport::Concern

  private

  def sort_records(records)
    case params[:sort]
    when 'oldest'
      records.order(created_at: :asc)
    when 'most_likes'
      records.left_joins(:likes)
              .group("#{records.table.name}.id")
              .order('COUNT(likes.id) DESC, created_at DESC')
    when 'least_likes'
      records.left_joins(:likes)
              .group("#{records.table.name}.id")
              .order('COUNT(likes.id) ASC, created_at DESC')
    when 'most_posts'
      if records.model == Theme
        records.left_joins(:posts)
                .group('themes.id')
                .order('COUNT(posts.id) DESC, themes.created_at DESC')
      else
        records.order(created_at: :desc)
      end
    when 'least_posts'
      if records.model == Theme
        records.left_joins(:posts)
                .group('themes.id')
                .order('COUNT(posts.id) ASC, themes.created_at DESC')
      else
        records.order(created_at: :desc)
      end
    else
      records.order(created_at: :desc)
    end
  end
end