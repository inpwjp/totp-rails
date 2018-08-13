require 'test_helper'

class TotpControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get totp_new_url
    assert_response :success
  end

end
