require 'capybara/rspec'
require 'capybara/dsl'
require 'capybara/poltergeist'

Capybara.configure do |config|
  # config.default_driver = :selenium
  config.javascript_driver = :poltergeist
  # config.app_host = 'https://enigmatic-ocean-39405.herokuapp.com'
  config.app = Rack::Builder
    .parse_file(File.expand_path('../../../config.ru', __FILE__)).first
end
