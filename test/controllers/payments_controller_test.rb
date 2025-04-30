require "test_helper"

class PaymentsControllerTest < ActionDispatch::IntegrationTest
  test "should get success" do
    get payments_success_url
    assert_response :success
  end

  test "should get cancel" do
    get payments_cancel_url
    assert_response :success
  end
end
