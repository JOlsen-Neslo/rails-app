require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test "full_title returns base title when page title is nil" do
    assert_equal 'Ruby on Rails Tutorial Sample App', full_title
  end

  test "full_title returns base title when page title is empty" do
    assert_equal 'Ruby on Rails Tutorial Sample App', full_title('')
  end

  test "full_title returns base title and page title when page title not empty or nil" do
    assert_equal 'Help | Ruby on Rails Tutorial Sample App', full_title('Help')
  end
end
