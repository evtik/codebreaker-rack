require_relative '../feature_helper'
require_relative '../../lib/racker'

feature 'hint page', type: :feature do
  before(:example) do
    game_session = Racker::GameSession.new
    page.set_rack_session(cb_session: game_session)
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
