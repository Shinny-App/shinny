require "test_helper"

class RegistrationsControllerTest < ActionDispatch::IntegrationTest
  test "GET new renders sign-up form" do
    get new_registration_path
    assert_response :success
  end

  test "POST create with valid params creates user and redirects" do
    assert_difference "User.count", 1 do
      post registration_path, params: {
        user: {
          email_address: "newuser@example.com",
          password: "password123",
          password_confirmation: "password123",
          display_name: "New User"
        }
      }
    end
    assert_redirected_to root_path
  end

  test "POST create with missing display_name re-renders form with 422" do
    assert_no_difference "User.count" do
      post registration_path, params: {
        user: {
          email_address: "newuser@example.com",
          password: "password123",
          password_confirmation: "password123",
          display_name: ""
        }
      }
    end
    assert_response :unprocessable_entity
  end

  test "POST create with duplicate email re-renders form with 422" do
    assert_no_difference "User.count" do
      post registration_path, params: {
        user: {
          email_address: users(:one).email_address,
          password: "password123",
          password_confirmation: "password123",
          display_name: "Duplicate"
        }
      }
    end
    assert_response :unprocessable_entity
  end
end
