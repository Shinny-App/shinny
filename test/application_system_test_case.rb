require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :rack_test

  private

  def sign_in_as(user, password: "password")
    visit new_session_url
    fill_in "Email address", with: user.email_address
    fill_in "Password", with: password
    click_button "Sign in"
  end
end
