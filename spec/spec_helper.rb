# frozen_string_literal: true

require 'rspec'
require 'capybara/rspec'
require 'capybara/dsl'
require 'selenium/webdriver'
require 'yaml'
require 'active_support/core_ext/hash/indifferent_access'
require 'active_support/inflector'
require 'pry'
require 'axe/rspec'
require 'dotenv'
require 'faker'
require 'site_prism'
require 'rspec/repeat'
require 'factory_bot'
require 'capybara-screenshot/rspec'
require 'down'
require 'active_support/dependencies'
require 'active_support/concern'

# Load env variables from .env
Dotenv.overload '.env'

# DON'T DO THIS ANYMORE
# This will load ALL support files (page objects, helpers, etc.) for any test, even if they
# don't need them to run successfully.
# We now adhere to a strict naming policy that allows us to use ActiveSupport autoloading
# capabilities.
# Dir['./spec/support/test_helpers/**/*.rb'].each { |f| require f }
ActiveSupport::Dependencies.autoload_paths = Dir['./spec/support/**/', './spec/data/**/', './spec/helpers/']

yml_files_path = File.join('./', 'spec', 'data', TestHelpers::Rspec.environment_fixture, '*.yml')
yml_files = Dir[yml_files_path]

FIXTURES = ActiveSupport::HashWithIndifferentAccess.new(
    yml_files.each_with_object({}) { |f, h| h.deep_merge!(YAML.safe_load(ERB.new(File.read(f)).result)) }
)

RSpec.configure do |config|
  config.include Capybara::DSL
  config.include Capybara::RSpecMatchers
  config.include FactoryBot::Syntax::Methods
  config.alias_it_should_behave_like_to :it_has_behavior, 'has behavior:'

  # This needs to be called in order for FactoryBot to find and autoload
  # factories defined under 'spec/factories'.
  config.prepend_before :suite do
    FactoryBot.find_definitions
  end
end

# Repeat configuration
RETRIES = 3

REPEATABLE_EXCEPTIONS = [
    Net::ReadTimeout,
    Timeout::Error
].freeze

RSpec.configure do |config|
  config.include RSpec::Repeat
  config.around :each, type: :feature do |example|
    repeat example, RETRIES.times, clear_let: true, verbose: true, exceptions: REPEATABLE_EXCEPTIONS
  end
end

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
    expectations.syntax = %i[should expect]
  end

  # rspec-mocks config goes here. You can use an alternate test double
  # library (such as bogus or mocha) by changing the `mock_with` option here.
  config.mock_with :rspec do |mocks|
    # Prevents you from mocking or stubbing a method that does not exist on
    # a real object. This is generally recommended, and will default to
    # `true` in RSpec 4.
    mocks.verify_partial_doubles = true
  end

  config.filter_run_excluding exclude: true
end

# with_repeat method helper
def with_repeat # rubocop:disable Metrics/MethodLength
  attempt = 1
  RETRIES.times do
    begin
      yield
      break
    rescue StandardError => e
      raise e unless REPEATABLE_EXCEPTIONS.member?(e.class) && attempt < RETRIES

      attempt += 1
    ensure
      Capybara.reset!
    end
  end
end