require 'test_helper'

class TrelloCredentialsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get trello_credentials_show_url
    assert_response :success
  end

  test "should get edit" do
    get trello_credentials_edit_url
    assert_response :success
  end

  test "should get new" do
    get trello_credentials_new_url
    assert_response :success
  end

  test "should get update" do
    get trello_credentials_update_url
    assert_response :success
  end

  test "should get create" do
    get trello_credentials_create_url
    assert_response :success
  end

end
