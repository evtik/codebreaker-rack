require_relative '../feature_helper'

feature 'game page', type: :feature do
  before(:example) do
    visit '/game'
  end

  scenario 'has a hint panel' do
    expect(page).to have_css('.panel .panel-body', text: /hint/i)
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

  scenario 'marks invalid input' do
    fill_in('Enter your guess', with: '1wer')
    find_button('Submit code').click
    expect(page).to have_css('.panel-danger .panel-heading h4',
                             text: /invalid input/i)
    expect(page).to have_css('.panel-body', text: '1wer')
  end

  scenario 'marks less than 4 correct digits as invalid' do
    fill_in('Enter your guess', with: '123')
    find_button('Submit code').click
    expect(page).to have_css('.panel-danger .panel-heading h4',
                             text: /invalid input/i)
    expect(page).to have_css('.panel-body', text: '123')
  end

  scenario 'marks more than 4 correct digits as invalid' do
    fill_in('Enter your guess', with: '12345')
    find_button('Submit code').click
    expect(page).to have_css('.panel-danger .panel-heading h4',
                             text: /invalid input/i)
    expect(page).to have_css('.panel-body', text: '12345')
  end

  scenario 'marks digits greater than 6 as invalid' do
    fill_in('Enter your guess', with: '1237')
    find_button('Submit code').click
    expect(page).to have_css('.panel-danger .panel-heading h4',
                             text: /invalid input/i)
    expect(page).to have_css('.panel-body', text: '1237')
  end
end
