require 'test_helper'

class WebUsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @web_user = web_users(:one)
  end

  test "should get index" do
    get web_users_url
    assert_response :success
  end

  test "should get new" do
    get new_web_user_url
    assert_response :success
  end

  test "should create web_user" do
    assert_difference('WebUser.count') do
      post web_users_url, params: { web_user: { date_of_birth: @web_user.date_of_birth, email_id: @web_user.email_id, is_admin: @web_user.is_admin, is_regestered: @web_user.is_regestered, user_name: @web_user.user_name, user_type: @web_user.user_type } }
    end

    assert_redirected_to web_user_url(WebUser.last)
  end

  test "should show web_user" do
    get web_user_url(@web_user)
    assert_response :success
  end

  test "should get edit" do
    get edit_web_user_url(@web_user)
    assert_response :success
  end

  test "should update web_user" do
    patch web_user_url(@web_user), params: { web_user: { date_of_birth: @web_user.date_of_birth, email_id: @web_user.email_id, is_admin: @web_user.is_admin, is_regestered: @web_user.is_regestered, user_name: @web_user.user_name, user_type: @web_user.user_type } }
    assert_redirected_to web_user_url(@web_user)
  end

  test "should destroy web_user" do
    assert_difference('WebUser.count', -1) do
      delete web_user_url(@web_user)
    end

    assert_redirected_to web_users_url
  end
end
