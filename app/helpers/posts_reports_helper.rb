module PostsReportsHelper
  def reason_category_name(report)
    return '' if report.nil? || report.reason_category.nil?

    t("posts_reports.reason_categories.#{report.reason_category}")
  end
end