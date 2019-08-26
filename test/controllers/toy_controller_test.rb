require 'test_helper'

class ToyControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get toy_index_url
    assert_response :success
  end

end
