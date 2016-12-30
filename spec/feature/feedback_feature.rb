require_relative '../feature_helper'

feature 'feedback table', type: :feature do
  before(:example) do
    visit '/game'
    fill_in 'Enter your guess', with: '1234'
    find_button('Submit code').click
  end

  scenario 'shows feedback table title' do
    expect(page).to have_css('.panel-heading', text: /here are the feedbacks/i)
  end

  scenario 'shows td with code submitted' do
    expect(page).to have_css('td', text: '1234')
  end
end
