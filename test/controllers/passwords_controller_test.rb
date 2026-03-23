require "test_helper"

class PasswordsControllerTest < ActionDispatch::IntegrationTest
  test "GET new renders password reset form" do
    get new_password_path
    assert_response :success
  end

  test "POST create with valid email sends reset email" do
    user = users(:one)
    assert_enqueued_emails 1 do
      post passwords_path, params: { email_address: user.email_address }
    end
    assert_redirected_to new_session_path
  end

  test "POST create with unknown email still responds normally (no user enumeration)" do
    post passwords_path, params: { email_address: "unknown@example.com" }
    assert_redirected_to new_session_path
  end

  test "GET edit with valid token renders reset form" do
    user = users(:one)
    token = user.generate_token_for(:password_reset)
    get edit_password_path(token)
    assert_response :success
  end

  test "PATCH update with valid token and password resets password" do
    user = users(:one)
    token = user.generate_token_for(:password_reset)
    patch password_path(token), params: { password: "newpassword123", password_confirmation: "newpassword123" }
    assert_redirected_to new_session_path
    assert user.reload.authenticate("newpassword123")
  end

  test "GET edit with invalid token redirects with error" do
    get edit_password_path("invalid-token")
    assert_redirected_to new_password_path
  end

  test "GET edit with valid token for deleted user redirects with error" do
    user = users(:one)
    token = user.generate_token_for(:password_reset)
    user.destroy!
    get edit_password_path(token)
    assert_redirected_to new_password_path
  end
end
