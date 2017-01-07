require_relative '../feature_helper'

feature 'game over panel', type: :feature do
  scenario 'shows correct message and game over controls' do
    ten_times_submit_guess
    expect(page).to have_css('.alert-danger', text: /you lost/i)
    expect(page).to have_link('Play again')
    expect(page).to have_link('Save results')
  end
end
