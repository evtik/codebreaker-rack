require 'capybara/rspec'
require 'capybara/dsl'
require_relative '../../lib/racker'

Capybara.configure do |config|
  config.default_driver = :selenium
  # config.app_host = 'https://enigmatic-ocean-39405.herokuapp.com'
  config.app = Rack::Builder
    .parse_file(File.expand_path('../../../config.ru', __FILE__)).first
end
