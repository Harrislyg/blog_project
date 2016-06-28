require 'rails_helper'

RSpec.describe 'Reading articles' do
  let(:user) { User.create(email: 'harry@hogwarts.edu', password: 'super_secret') }

  it 'lets visitors view articles' do
    article = user.articles.create(title: 'Post one', body: 'Body 1')

    visit user_article_path(user, article)

    expect(page.current_path).to eq user_article_path(user, article)
    expect(page).to have_content 'Post one'
    expect(page).to have_content 'Body 1'
  end

  it "shows everyone's articles sorted in reverse chrono order (newest first) on the home page" do
    dumbledore = User.create(email: 'dumbledore@hogwarts.edu', password: 'super_secret')
    snape = User.create(email: 'snape@hogwarts.edu', password: 'super_secret')
    sprout = User.create(email: 'sprout@hogwarts.edu', password: 'super_secret')

    dumbledore.articles.create(title: 'Oldest Title', body: 'oldest body', created_at: 2.days.ago)
    snape.articles.create(title: 'Middle Title', body: 'miiddle body', created_at: 1.day.ago)
    dumbledore.articles.create(title: 'Newest Title', body: 'newest body', created_at: 6.hours.ago)

    ensure_on(home_path)

    articles = page.find_all('.articles .article')
    expect(articles.size).to eq 3

    within articles.first do
      expect(page).to have_content('Newest Title')
      expect(page).to have_content('newest body')
    end

    within articles.last do
      expect(page).to have_content('Oldest Title')
      expect(page).to have_content('oldest body')
    end
  end
end
