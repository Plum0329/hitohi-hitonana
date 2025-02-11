# frozen_string_literal: true

require 'test_helper'

class PostsDeletionRequestsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:user_1)
    @post = posts(:post_1)
    @posts_deletion_request = posts_deletion_requests(:one)
    login_as(@user)
  end

  test 'should get new' do
    get new_post_posts_deletion_request_path(@post)
    assert_response :success
  end

  test 'should get confirm' do
    post confirm_post_posts_deletion_requests_path(@post), params: {
      posts_deletion_request: {
        reason: 'テスト削除理由' * 3
      }
    }
    assert_response :success
  end

  test 'should create posts_deletion_request' do
    assert_difference('PostsDeletionRequest.count') do
      post post_posts_deletion_requests_path(@post), params: {
        posts_deletion_request: {
          reason: 'テスト削除理由' * 3
        }
      }
    end
    assert_redirected_to posts_deletion_request_path(PostsDeletionRequest.last)
  end

  test 'should show posts_deletion_request' do
    get posts_deletion_request_path(@posts_deletion_request)
    assert_response :success
  end
end
