require 'test_helper'

class OwnersControllerTest < ActionDispatch::IntegrationTest
  test "should get create_owner" do
    get owners_create_owner_url
    assert_response :success
  end

end
