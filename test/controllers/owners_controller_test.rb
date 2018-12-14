require 'test_helper'

class OwnersControllerTest < ActionDispatch::IntegrationTest
	test "should get create_owner" do
		get owners_create_url
		body = JSON.parse(response.body)
		puts body
		assert_response :success
	end

end
