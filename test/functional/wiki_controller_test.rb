require 'test_helper'

class WikiControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get create" do
    get(:create, {"wiki_page"=>{"content"=>"1", "title"=>"test1"}})
    # assert_response :success
  end

end
