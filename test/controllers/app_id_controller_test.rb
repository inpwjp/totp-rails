require 'test_helper'

class AppIdControllerTest < ActionDispatch::IntegrationTest
  test "should get app_id" do
    get app_id_app_id_url
    assert_response :success
  end

end
