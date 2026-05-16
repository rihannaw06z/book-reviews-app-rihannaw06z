require "test_helper"

class BooksByControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get books_by_index_url
    assert_response :success
  end
end
