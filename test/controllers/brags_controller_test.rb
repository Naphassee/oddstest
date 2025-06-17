require "test_helper"

class BragsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get brags_index_url
    assert_response :success
  end
end
