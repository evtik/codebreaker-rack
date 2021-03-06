require_relative 'config/capybara'

RSpec.configure do |config|
  config.color = true
  config.formatter = 'documentation'
end

def ten_times_submit_guess
  visit '/game'
  # of course, the test will fail if the game code happens to be 1234 :-)
  10.times do
    fill_in('Enter your guess', with: '1234')
    find_button('Submit code').click
  end
end
