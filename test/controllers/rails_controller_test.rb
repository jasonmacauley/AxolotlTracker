require 'test_helper'

class RailsControllerTest < ActionDispatch::IntegrationTest
  test "should get db:create" do
    get rails_db:create_url
    assert_response :success
  end

  test "should get AxolotlTracker" do
    get rails_AxolotlTracker_url
    assert_response :success
  end

end
