require 'database_cleaner'

RSpec.configure do |config|
  config.before(:suite) do
    # Do truncation once per suite to vacuum for Postgres
    DatabaseCleaner.clean_with :truncation
    # Normally do transactions-based cleanup
    # DatabaseCleaner.strategy = :transaction
  end

  config.before(:each) do
    # FIXME: we want transaction but it's not worling well, deal with after upgrades
    DatabaseCleaner.strategy = :truncation
  end

  # config.before(:each, type: :feature) do
  #   # :rack_test driver's Rack app under test shares database connection
  #   # with the specs, so continue to use transaction strategy for speed.
  #   driver_shares_db_connection_with_specs = Capybara.current_driver == :rack_test
  #
  #   unless driver_shares_db_connection_with_specs
  #     # Driver is probably for an external browser with an app
  #     # under test that does *not* share a database connection with the
  #     # specs, so use truncation strategy.
  #     DatabaseCleaner.strategy = :truncation
  #   end
  # end
  #
  # config.before(:each) do
  #   DatabaseCleaner.start
  # end
  #
  # config.append_after(:each) do
  #   DatabaseCleaner.clean
  # end
end
