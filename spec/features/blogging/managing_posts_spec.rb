require 'rails_helper'

RSpec.describe 'Blogging' do
  let(:user) { User.create(email: 'harry@hogwarts.edu', password: 'super_secret') }

  context 'when signed in' do
    before do
      sign_in_as(user)
    end

    it 'lets the user create a new post' do
      ensure_on new_article_path(user)

      fill_in 'Title', with: 'The Title'
      fill_in 'Body', with: 'The Article Body'
      click_on 'Create Article'

      expect(page).to have_content('successfully created')
      expect(page).to have_content('The Title')
      expect(page).to have_content('The Article Body')
      expect(page.current_path).to eq article_path(user, Article.last)
    end

    it 'lets the user view a list of all of their posts with links to view, edit, and delete them' do
      post_one = user.posts.create(title: 'Article one', body: 'Body 1')
      post_two = user.posts.create(title: 'Article two', body: 'Body 2')

      ensure_on articles_path(user)

      expect(page).to have_content 'Article one'
      expect(page).to have_link 'Show', href: article_path(user, post_one)
      expect(page).to have_link 'Edit', href: edit_article_path(user, post_one)
      expect(page).to have_link 'Destroy', href: article_path(user, post_one)

      expect(page).to have_content 'Article two'
    end

    it 'lets the user view their posts' do
      post = user.posts.create(title: 'Article one', body: 'Body 1')
      ensure_on articles_path(user)
      click_on 'Show'

      expect(page.current_path).to eq article_path(user, post)
      expect(page).to have_content 'Article one'
      expect(page).to have_content 'Body 1'
    end

    it 'lets the user edit posts' do
      post = user.posts.create(title: 'Article one', body: 'Body 1')
      ensure_on articles_path(user)
      click_on 'Edit'

      expect(page.current_path).to eq edit_article_path(user, post)

      fill_in 'Title', with: 'Updated Title'
      fill_in 'Body', with: 'Updated Body'
      click_on 'Update Article'

      expect(page).to have_content 'successfully updated'
      expect(page).to have_content 'Updated Title'
      expect(page).to have_content 'Updated Body'
      expect(page.current_path).to eq article_path(user, post)
    end

    it 'lets the user delete their posts' do
      post = user.posts.create(title: 'Article one', body: 'Body 1')
      ensure_on articles_path(user)

      expect(page).to have_content('Article one')

      click_on 'Destroy'

      expect(page).to_not have_content('Article one')
      expect(page).to have_content('successfully destroyed')

      expect(page.current_path).to eq articles_path(user)
    end

    # TODO: this test is probably better moved to a request spec (because I like to keep
    # feature specs testing the happy path only)
    it "does not let a user edit other people's posts" do
      ron = User.create(email: 'ron@hogwarts.edu', password: 'super_secret')
      post = ron.posts.create(title: 'Article one', body: 'Body 1')
      visit edit_article_path(ron, post)
      expect(page.current_path).to eq home_path
      expect(page).to have_content "This post doesn't belong to you!"
    end
  end

  context 'when not signed in' do
    # TODO: this test is probably better moved to a request spec (because I like to keep
    # feature specs testing the happy path only)
    it 'does not let users create, or edit posts' do
      harry = User.create(email: 'harry@hogwarts.edu', password: 'super_secret')

      visit new_article_path(harry)
      expect(page.current_path).to eq home_path
      expect(page).to have_content 'You must log in to access this page.'

      post = harry.posts.create(title: 'Article one', body: 'Body 1')
      visit edit_article_path(harry, post)
      expect(page.current_path).to eq home_path
    end
  end
end
