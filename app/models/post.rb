class Post < ApplicationRecord
  attr_accessor :tag_id
  belongs_to :user
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags

  validates :reading, presence: { message: "読み方を入力してください" }
  validates :display_content, presence: { message: "本文が入力されていません" }

  validate :reading_validation
  validate :content_reading_consistency
  validate :tag_presence_validation

  def reading_validation
    return if reading.blank?
    
    unless reading.match?(/\A[ぁ-んァ-ン゛゜ー・　\s]*\z/)
      errors.add(:reading, :kana_only_reading)
      return
    end

    syllable_count = count_syllables(reading)
    if syllable_count == 0
      errors.add(:reading, :syllable_blank_reading)
    elsif syllable_count > 20
      errors.add(:reading, :syllable_count, count: 20, current: syllable_count)
    end
  end

  def content_reading_consistency
    return if reading.blank? || display_content.blank?

    reading_length = reading.gsub(/[\s　]/,'').length
    content_length = display_content.gsub(/[\s　]/,'').length
    
    if content_length < (reading_length / 2)
      errors.add(:base, "本文が読みと比べて短すぎるようです")
    elsif content_length > (reading_length * 2)
      errors.add(:base, "本文が読みと比べて長すぎるようです")
    end
  end

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

  def tag_presence_validation
    if tags.empty?
      errors.add(:base, "俳句か川柳を選択してください")
    elsif tags.count > 1
      errors.add(:base, "俳句か川柳のどちらか一方を選択してください")
    end
  end
end