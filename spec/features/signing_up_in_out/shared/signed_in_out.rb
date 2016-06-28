require 'rails_helper'

RSpec.shared_examples "a signed in user" do
  it "shows the user's email address" do
    expect(page).to have_content(user.email)
  end

  it "shows a sign out link" do
    expect(page).to have_link('Sign Out', href: sign_out_path)
  end

  it "shows a link to create a new post" do
    expect(page).to have_link 'New Article', href: new_article_path
  end
end
