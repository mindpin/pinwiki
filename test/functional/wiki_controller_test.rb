require 'test_helper'

class WikiControllerTest < ActionController::TestCase

  test "should post create" do
    assert_difference('WikiPage.count') do
      post(:create)
    end
    # assert_redirected_to "/wiki/#{assigns(:wiki_page)}"
    # assert_response :success
  end
  
  test "should put update" do
    put(:update)
  end
  

end
