namespace :posts do
  desc "Fix posts without themes"
  task fix_themes: :environment do
    Post.includes(:theme, :image_post).find_each do |post|
      next if post.theme.present? || !post.image_post.present?

      # 既存のお題を探すか、新しく作成
      theme = post.image_post.themes.first_or_create! do |t|
        t.user = post.user
        t.description = post.image_post.description
        t.image.attach(post.image_post.image.blob) if post.image_post.image.attached?
      end

      post.update!(theme: theme)
      puts "Fixed post ID: #{post.id} with theme ID: #{theme.id}"
    end
  end
end