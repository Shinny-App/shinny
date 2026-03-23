require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "GET new renders sign-in form" do
    get new_session_path
    assert_response :success
  end

  test "POST create with valid credentials creates session and redirects" do
    user = users(:one)
    assert_difference "Session.count", 1 do
      post session_path, params: { email_address: user.email_address, password: "password123" }
    end
    assert_redirected_to root_path
  end

  test "POST create with invalid credentials re-renders with redirect" do
    user = users(:one)
    assert_no_difference "Session.count" do
      post session_path, params: { email_address: user.email_address, password: "wrongpassword" }
    end
    assert_redirected_to new_session_path
  end

  test "DELETE destroy logs out and redirects" do
    user = users(:one)
    post session_path, params: { email_address: user.email_address, password: "password123" }

    assert_difference "Session.count", -1 do
      delete session_path
    end
    assert_redirected_to new_session_path
  end
end
