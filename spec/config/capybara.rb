require 'capybara/rspec'
require 'capybara/dsl'
require_relative '../../lib/racker'

Capybara.default_driver = :selenium
Capybara.app = Racker.new
