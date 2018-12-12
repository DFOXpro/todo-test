require 'test_helper'

class ApplicationControllerTest < ActionDispatch::IntegrationTest
  test "should get root" do
    get application_root_url
    assert_response :success
  end

end
