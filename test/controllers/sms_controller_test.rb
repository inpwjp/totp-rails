require 'test_helper'

class SmsControllerTest < ActionDispatch::IntegrationTest
  test "should get edit" do
    get sms_edit_url
    assert_response :success
  end

  test "should get create" do
    get sms_create_url
    assert_response :success
  end

  test "should get confirm" do
    get sms_confirm_url
    assert_response :success
  end

  test "should get check" do
    get sms_check_url
    assert_response :success
  end

end
