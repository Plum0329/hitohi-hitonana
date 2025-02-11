# frozen_string_literal: true

require 'test_helper'

class PostsDeletionRequestTest < ActiveSupport::TestCase
  def setup
    @user = users(:user_1)
    @post = posts(:post_1)
    @posts_deletion_request = PostsDeletionRequest.new(
      user: @user,
      post: @post,
      reason: 'テスト削除理由' * 3
    )
  end

  test 'should be valid' do
    assert @posts_deletion_request.valid?
  end

  test 'should require a reason' do
    @posts_deletion_request.reason = ''
    assert_not @posts_deletion_request.valid?
  end

  test 'reason should not be too short' do
    @posts_deletion_request.reason = 'あ' * 9
    assert_not @posts_deletion_request.valid?
  end

  test 'reason should not be too long' do
    @posts_deletion_request.reason = 'あ' * 1001
    assert_not @posts_deletion_request.valid?
  end

  test 'should have pending status by default' do
    assert_equal 'pending', @posts_deletion_request.status
  end

  test 'should not allow duplicate pending requests for the same post' do
    @posts_deletion_request.save
    duplicate_request = PostsDeletionRequest.new(
      user: users(:user_2),
      post: @post,
      reason: '別のユーザーからの削除申請'
    )
    assert_not duplicate_request.valid?
  end
end
