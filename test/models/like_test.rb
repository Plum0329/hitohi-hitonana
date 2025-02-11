# frozen_string_literal: true

require 'test_helper'

class LikeTest < ActiveSupport::TestCase
  def setup
    @user = users(:one)
    @post = posts(:one)
    @theme = themes(:one)
    @like = Like.new(user: @user, likeable: @post)
  end

  test 'should be valid' do
    assert @like.valid?
  end

  test 'should require a user' do
    @like.user = nil
    assert_not @like.valid?
  end

  test 'should require a likeable' do
    @like.likeable = nil
    assert_not @like.valid?
  end

  test 'should not allow duplicate likes' do
    @like.save
    duplicate_like = @like.dup
    assert_not duplicate_like.valid?
  end

  test 'should not allow user to like their own content' do
    own_post = Post.create!(
      user: @user,
      reading: 'てすと',
      display_content: 'テスト'
    )
    like = Like.new(user: @user, likeable: own_post)
    assert_not like.valid?
  end
end
