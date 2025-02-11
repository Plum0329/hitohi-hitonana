# frozen_string_literal: true

require 'test_helper'

class ImagePostsControllerTest < ActionDispatch::IntegrationTest
  test 'should get new' do
    get image_posts_new_url
    assert_response :success
  end

  test 'should get create' do
    get image_posts_create_url
    assert_response :success
  end
end
