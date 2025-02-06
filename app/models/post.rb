class Post < ApplicationRecord
  scope :for_theme, ->(theme_id) { where(theme_id: theme_id).includes(:user, :tags) }
  scope :chronological, -> { order(created_at: :asc) }
  scope :reverse_chronological, -> { order(created_at: :desc) }
  scope :available, -> { where(deleted_at: nil) }
  scope :deleted, -> { where.not(deleted_at: nil) }

  attr_accessor :tag_id
  attr_accessor :skip_tag_validation
  belongs_to :user
  belongs_to :image_post, optional: true
  belongs_to :theme, counter_cache: true, optional: true
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags
  has_many :likes, as: :likeable, dependent: :destroy
  has_many :users_who_liked, through: :likes, source: :user
  has_many :deletion_requests

  validates :reading, presence: { message: "読み方を入力してください" }
  validates :display_content, presence: { message: "本文が入力されていません" }

  validate :reading_validation
  validate :tag_presence_validation, unless: -> { skip_tag_validation || destroyed? }
  validate :content_reading_consistency, unless: -> { skip_tag_validation || destroyed? }
  validate :validate_reading_spaces
  validate :validate_display_content_newlines

  after_save :check_syllable_count_tags
  after_destroy :destroy_orphaned_image_post
  after_destroy :cleanup_image_post

  def soft_delete
    self.skip_tag_validation = true
    update(deleted_at: Time.current)
  end

  def restore
    self.skip_tag_validation = true
    update(deleted_at: nil)
  end

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

  def validate_reading_spaces
    # 全角空白を半角空白に統一
    normalized_reading = reading.gsub('　', ' ')

    # 連続した空白のチェック
    if normalized_reading.match?(/\s{2,}/)
      errors.add(:reading, "空白は連続して入力できません")
      return
    end

    # 空白文字数のカウント
    space_count = normalized_reading.count(' ')

    unless (1..2).include?(space_count)
      errors.add(:reading, "句全体で1つまたは2つの空白を入れてください")
    end
  end

  def validate_display_content_newlines
    return if display_content.blank?

    # 改行の数をカウント
    newline_count = display_content.count("\n")

    # 改行数のバリデーション（1以上2以下）
    if newline_count < 1
      errors.add(:display_content, "句全体で1つまたは2つの改行を入れてください")
    elsif newline_count > 2
      errors.add(:display_content, "3つ以上の改行は入力できません")
    end

    # 本文の最初と最後に改行がないかチェック
    if display_content.start_with?("\n") || display_content.end_with?("\n")
      errors.add(:display_content, "句の最初と最後に改行を入れることはできません")
    end

    # 連続した改行がないかチェック
    if display_content.match?(/\n\n/)
      errors.add(:display_content, "連続した改行は入力できません")
    end
  end

  def destroy_orphaned_image_post
    if image_post && image_post.posts.empty?
      image_post.destroy
    end
  end

  def check_syllable_count_tags
    # 既存の字足らず・字余りタグを削除
    tags.where(name: ['字足らず', '字余り']).each do |tag|
      post_tags.find_by(tag: tag)&.destroy
    end

    # 音数を計算（既存のcount_syllablesメソッドを使用）
    syllables = count_syllables(reading)

    # タグを付与
    if syllables < 17
      tags << Tag.find_by(name: '字足らず')
    elsif syllables > 17
      tags << Tag.find_by(name: '字余り')
    end
  end

  def cleanup_image_post
    if image_post.present? && !theme.present? && !image_post.posts.exists?
      image_post.destroy
    end
  end

  def has_pending_deletion_request?
    deletion_requests.where(status: 0).exists?
  end
end