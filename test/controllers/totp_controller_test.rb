require 'test_helper'

class TotpControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:user1)
  end

  test "should get check" do
    get check_totp_url, {params: {id: @user.id}}
    assert_response :success
  end
end
