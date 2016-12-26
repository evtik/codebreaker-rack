require_relative '../feature_helper'

feature 'index page', type: :feature do
  before(:example) do
    visit '/'
  end

  scenario 'has a valid title' do
    expect(page).to have_title('Codebreaker')
  end

  scenario 'has a welcome message' do
    expect(page).to have_css('h1', text: /welcome/i)
  end

  scenario "has a 'Play' button" do
    expect(page).to have_link('Play')
  end
end
