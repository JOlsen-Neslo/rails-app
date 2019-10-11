require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get login_path
    assert_response :success
  end

  test "should not fail post to create" do
    post login_path, params: {
        session: {
            name: "Example User",
            nickname: "nickname",
            email: "user@example.com",
            password: "password",
            password_confirmation: "password"
        }
    }
    assert_response :success
  end

  test "should not fail post to create with missing email" do
    post login_path, params: {
        session: {
            name: "Example User",
            nickname: "nickname",
            password: "password",
            password_confirmation: "password"
        }
    }
    assert_response :success
  end

  test "should redirect from destroy" do
    delete logout_path
    assert_response :found
  end
end
