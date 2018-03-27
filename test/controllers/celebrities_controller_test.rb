require 'test_helper'

class CelebritiesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @celebrity = celebrities(:one)
  end

  test "should get index" do
    get celebrities_url
    assert_response :success
  end

  test "should get new" do
    get new_celebrity_url
    assert_response :success
  end

  test "should create celebrity" do
    assert_difference('Celebrity.count') do
      post celebrities_url, params: { celebrity: { birth_year: @celebrity.birth_year, celebrity_name: @celebrity.celebrity_name, death_year: @celebrity.death_year, known_for: @celebrity.known_for, profession: @celebrity.profession } }
    end

    assert_redirected_to celebrity_url(Celebrity.last)
  end

  test "should show celebrity" do
    get celebrity_url(@celebrity)
    assert_response :success
  end

  test "should get edit" do
    get edit_celebrity_url(@celebrity)
    assert_response :success
  end

  test "should update celebrity" do
    patch celebrity_url(@celebrity), params: { celebrity: { birth_year: @celebrity.birth_year, celebrity_name: @celebrity.celebrity_name, death_year: @celebrity.death_year, known_for: @celebrity.known_for, profession: @celebrity.profession } }
    assert_redirected_to celebrity_url(@celebrity)
  end

  test "should destroy celebrity" do
    assert_difference('Celebrity.count', -1) do
      delete celebrity_url(@celebrity)
    end

    assert_redirected_to celebrities_url
  end
end
