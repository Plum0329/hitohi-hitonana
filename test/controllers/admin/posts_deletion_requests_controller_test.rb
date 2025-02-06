require "test_helper"

class Admin::PostsDeletionRequestsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @admin = users(:admin)
    @posts_deletion_request = posts_deletion_requests(:one)
    login_as(@admin)
  end

  test "should get index" do
    get admin_posts_deletion_requests_path
    assert_response :success
  end

  test "should get show" do
    get admin_posts_deletion_request_path(@posts_deletion_request)
    assert_response :success
  end

  test "should approve posts_deletion_request" do
    patch approve_admin_posts_deletion_request_path(@posts_deletion_request)
    assert_redirected_to admin_posts_deletion_requests_path
    @posts_deletion_request.reload
    assert @posts_deletion_request.approved?
  end

  test "should reject posts_deletion_request" do
    patch reject_admin_posts_deletion_request_path(@posts_deletion_request)
    assert_redirected_to admin_posts_deletion_requests_path
    @posts_deletion_request.reload
    assert @posts_deletion_request.rejected?
  end
end