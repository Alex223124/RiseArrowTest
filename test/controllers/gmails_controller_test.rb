require 'test_helper'

class GmailsControllerTest < ActionController::TestCase
  test "should get connect_and_archive" do
    get :connect_and_archive
    assert_response :success
  end

end
