require 'test_helper'

class AxolotlStatsControllerTest < ActionDispatch::IntegrationTest
  test "should get index," do
    get axolotl_stats_index,_url
    assert_response :success
  end

  test "should get show" do
    get axolotl_stats_show_url
    assert_response :success
  end

end
