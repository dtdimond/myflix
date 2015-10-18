require 'spec_helper'

feature "Signing in" do
  scenario "Signing in with correct credentials" do
    user = Fabricate(:user)
    sign_in(user)
    expect(page).to have_content user.full_name
  end
end