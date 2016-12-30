require_relative '../feature_helper'

feature 'username input', type: :feature do
  before(:example) do
    ten_times_submit_guess
    find_link('Save results').click
  end

  scenario 'has appropritate controls' do
    expect(page).to have_css('.panel-heading h4', text: 'Enter your name')
    expect(page).to have_field(name: 'username')
    expect(page).to have_button('Submit name')
    expect(page).not_to have_link('Save results')
  end

  scenario 'marks special chars as invalid' do
    fill_in(name: 'username', with: '%john')
    find_button('Submit name').click
    expect(page).to have_css('.panel-body', text: /%john/)
  end

  scenario 'marks more than one word as invalid' do
    fill_in(name: 'username', with: 'john jones')
    find_button('Submit name').click
    expect(page).to have_css('.panel-body', text: /john jones/)
  end

  scenario 'shows users table with valid input' do
    fill_in(name: 'username', with: 'john')
    find_button('Submit name').click
    expect(page).to have_css('h2', text: /users statistics/i)
    expect(page).to have_css('td', text: 'john')
  end
end
