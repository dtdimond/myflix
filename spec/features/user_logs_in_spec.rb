require 'spec_helper'

feature "Signing in" do
  background do
    Fabricate(:user, password: "password", email: "user@example.com")
  end

  scenario "Signing in with correct credentials" do
    visit login_path
    fill_in 'Email', with: 'user@example.com'
    fill_in 'Password', with: 'password'

    click_button 'Sign In'
    expect(page).to have_content "Welcome, you're logged in!"
  end
end