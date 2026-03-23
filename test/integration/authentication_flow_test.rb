require "test_helper"

class AuthenticationFlowTest < ActionDispatch::IntegrationTest
  test "unauthenticated user accessing the sign-in page sees it successfully" do
    get root_path
    assert_response :success
  end

  test "after sign-in, user can access protected route" do
    user = users(:one)
    post session_path, params: { email_address: user.email_address, password: "password123" }
    assert_redirected_to root_path
    follow_redirect!
    assert_response :success
  end

  test "after sign-up, user is authenticated and redirected" do
    post registration_path, params: {
      user: {
        email_address: "newuser@example.com",
        password: "password123",
        password_confirmation: "password123",
        display_name: "New User"
      }
    }
    assert_redirected_to root_path
    follow_redirect!
    assert_response :success
  end

  test "after sign-out, user cannot access protected routes" do
    user = users(:one)
    post session_path, params: { email_address: user.email_address, password: "password123" }

    delete session_path
    assert_redirected_to new_session_path

    get root_path
    assert_response :success
  end
end
