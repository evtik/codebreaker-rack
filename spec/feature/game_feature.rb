require_relative '../feature_helper'

feature 'game page', type: :feature do
  before(:example) do
    visit '/game'
  end

  scenario 'has a hint panel' do
    expect(page).to have_css('.panel .panel-heading h4', text: /hint/i)
  end

  scenario "has a 'Show hint' button" do
    expect(page).to have_link('Show hint')
  end

  scenario 'has an input for a guess' do
    expect(page).to have_field('guess')
  end

  scenario "has a 'Submit code' button" do
    expect(page).to have_css('button[type="submit"]', text: 'Submit code')
  end
end
