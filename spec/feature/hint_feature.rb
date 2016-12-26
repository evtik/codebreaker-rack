require_relative '../feature_helper'

feature 'hint page', type: :feature do
  before(:example) do
    visit '/game'
    find('a', text: /\AShow hint\z/).click
  end

  scenario 'shows a game hint' do
    puts self
    expect(page).to have_content('/has\s+\d{1}\s+at')
  end

  scenario "hides 'Show hint' button" do
    expect(page).not_to have_link('Show hint')
  end
end
