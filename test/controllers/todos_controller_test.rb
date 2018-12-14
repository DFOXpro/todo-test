require 'test_helper'

class TodosControllerTest < ActionDispatch::IntegrationTest
  test "should get list" do
    get todos_list_url
    assert_response :success
  end

end
