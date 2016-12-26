require 'capybara/rspec'
require 'capybara/dsl'
require 'rack_session_access/capybara'
require_relative '../../lib/racker'

Capybara.default_driver = :selenium
Capybara.app = Racker.new
