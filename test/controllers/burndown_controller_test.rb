require 'test_helper'

class BurndownControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get burndown_index_url
    assert_response :success
  end

  test "should get show" do
    get burndown_show_url
    assert_response :success
  end

  test "should get create" do
    get burndown_create_url
    assert_response :success
  end

  test "should get new" do
    get burndown_new_url
    assert_response :success
  end

  test "should get update" do
    get burndown_update_url
    assert_response :success
  end

  test "should get edit" do
    get burndown_edit_url
    assert_response :success
  end

end
