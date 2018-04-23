require 'test_helper'

class SidebarListControllerTest < ActionDispatch::IntegrationTest
  test "should get displaySidebarList" do
    get sidebar_list_displaySidebarList_url
    assert_response :success
  end

end
