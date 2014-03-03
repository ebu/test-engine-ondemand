require 'test_helper'

class Plugit::MetaControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

end
