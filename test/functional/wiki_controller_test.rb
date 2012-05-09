require 'test_helper'

class WikiControllerTest < ActionController::TestCase
  fixtures :users
  
  test "should post create" do
    assert_difference('WikiPage.count') do
      post(:create, :wiki_page => {:title => 'test12222', :content => 'content12222'})
    end
    # assert_redirected_to "/wiki/#{assigns(:wiki_page)}"
    # assert_response :success
  end
  

end
