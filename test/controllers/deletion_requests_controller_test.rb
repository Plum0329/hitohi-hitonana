require "test_helper"

class DeletionRequestsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get deletion_requests_new_url
    assert_response :success
  end

  test "should get confirm" do
    get deletion_requests_confirm_url
    assert_response :success
  end

  test "should get create" do
    get deletion_requests_create_url
    assert_response :success
  end

  test "should get show" do
    get deletion_requests_show_url
    assert_response :success
  end
end
