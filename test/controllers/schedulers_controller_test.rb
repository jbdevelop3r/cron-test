require "test_helper"

class SchedulersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get schedulers_index_url
    assert_response :success
  end
end
