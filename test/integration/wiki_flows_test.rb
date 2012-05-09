require 'test_helper'

class WikiFlowsTest < ActionDispatch::IntegrationTest
  
  
  # fixtures :users

  test "login and browse site" do
    get "/"
    assert_response :success
 
    post_via_redirect "/", :username => users(:linux).name, :password => users(:linux).password
    assert_equal '/', path
 
    assert_difference('WikiPage.count') do
      wiki_page = WikiPage.new
      wiki_page.title = 'test1'
      wiki_page.content = 'content1'
      wiki_page.creator_id = 1
      assert wiki_page.save
    end
    # assert_redirected_to "/wiki/#{assigns(:wiki_page)}"
    # assert_response :success
  end
end
