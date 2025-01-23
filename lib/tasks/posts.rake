namespace :posts do
  desc "Update syllable count tags for existing posts"
  task update_syllable_tags: :environment do
    puts "Updating syllable count tags for existing posts..."

    Post.find_each.with_index do |post, index|
      post.send(:check_syllable_count_tags)
      if (index + 1) % 100 == 0
        puts "Processed #{index + 1} posts"
      end
    end

    puts "Completed updating syllable count tags!"
  end
end