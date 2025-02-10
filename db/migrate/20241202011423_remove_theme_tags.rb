class RemoveThemeTags < ActiveRecord::Migration[7.0]
  def up
    theme_tag = Tag.find_by(name: 'お題から詠まれた句')
    if theme_tag
      PostTag.where(tag_id: theme_tag.id).delete_all
      theme_tag.destroy
    end
  end

  def down
    Tag.create(name: 'お題から詠まれた句')
  end
end