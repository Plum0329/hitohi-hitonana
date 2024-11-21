class Post < ApplicationRecord
  belongs_to :user

  validates :content, presence: true
  validate :kana_only_validation
  validate :syllable_count_validation

  # privateからpublicに移動
  def count_syllables(text)
    return 0 if text.blank?
    
    text = text.tr('ァ-ン', 'ぁ-ん')
    chars = text.chars
    count = 0
    i = 0
    
    while i < chars.length
      case chars[i]
      when /[あ-ん]/
        if i < chars.length - 1
          case chars[i + 1]
          when /[ぁぃぅぇぉゃゅょ]/  # 拗音
            count += 1
            i += 2
            next
          when 'ー'  # 長音
            count += 1
            i += 2
            next
          end
        end
        count += 1
      when 'ん'  # 撥音
        count += 1
      when 'っ'  # 促音
        count += 1
      end
      i += 1
    end
    
    count
  end
  
  private

  def kana_only_validation
    return if content.blank?
    
    unless content.match?(/\A[ぁ-んァ-ン゛゜ー・、。　\s]*\z/)
      errors.add(:base, "ひらがな・カタカナのみ使用できます")
      return
    end
  end
  
  def syllable_count_validation
    return if content.blank?
    return unless content.match?(/\A[ぁ-んァ-ン゛゜ー・、。　\s]*\z/)
    
    syllable_count = count_syllables(content)
    if syllable_count == 0
      errors.add(:base, "句を入力してください")
    elsif syllable_count > 20
      errors.add(:base, "20音以下で入力してください（現在: #{syllable_count}音）")
    end
  end
end