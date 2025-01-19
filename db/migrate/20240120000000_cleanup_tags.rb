class CleanupTags < ActiveRecord::Migration[7.0]
  def up
    # 俳句と川柳以外のタグを削除
    Tag.where.not(name: ['俳句', '川柳']).destroy_all
  end

  def down
    # 元に戻す処理は不要
  end
end