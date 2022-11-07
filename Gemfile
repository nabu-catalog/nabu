source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.2"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.0.4"

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"

# Use mysql as the database for Active Record
gem "mysql2", "~> 0.5"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 5.0"

# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "importmap-rails"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

# Use Redis adapter to run Action Cable in production
# gem "redis", "~> 4.0"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
#gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Sass to process CSS
# gem "sassc-rails"

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-ge
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"
end

###################
# Our stuff
###################

# Needs to be as early as possible to do it's job
gem 'dotenv-rails', groups: [:development, :test] # Load env variables in dev

# Views
gem "haml-rails", "~> 2.0" # We use HAML for templates instead of erb
gem "kaminari" # Pagination
gem "oai" # OAI-PMH
gem "to-csv", :name => "to_csv" # TODO: This is no longer supported, remove this and implement ourselves. Only used by collections, items already has a custom implementation

# Analytics and instrumentation
gem "analytical" # Add google analytics TODO: outdated replace with something newer
gem "rollbar" # Error reporting
gem "newrelic_rpm" # Performance monitoring

# AAA
gem "devise" # Authentication
gem "cancancan" # Authorisation
gem "recaptcha" # Avoid fake registrations

# Database improvements
gem "nilify_blanks" # Convert empty strings to NULL in the DB where possible
gem "paper_trail" # Keep an audit trail of all the changes

# Background processing
gem "delayed_job_active_record" # Delay jobs and queue them in the database
gem "daemons" # Needed by delayed_job

# Frameworks
gem "activeadmin"

# Other
gem "roo" # Spreadsheet interface
gem "roo-xls" # Add excel support to roo
gem "ruby-filemagic" # Detect file types
gem "streamio-ffmpeg" # ffmpeg interface
gem "rmagick" # Image processing
gem "timeliness" # Date parsing
gem "whenever", :require => false # scheduling





# Databases
gem "graphql"
gem "graphiql-rails"

# Admin
gem "country-select"
gem "bootstrap-sass"

# Search
gem "sunspot_rails"

# Media Detection

# Deployment
gem "capistrano", "~> 2"
gem "capistrano-unicorn"
gem "capistrano-rbenv", "~> 1"

group :development, :test do
  gem "test-unit"
  gem "turn", :require => false
  gem "rspec-rails"
  gem "rails-controller-testing"
  gem "thin"

  gem "pry"
  gem "pry-byebug"
  gem "pry-rails"

  gem "letter_opener"

  gem "rb-inotify", :require => RUBY_PLATFORM.include?("linux") ? "rb-inotify" : false
  gem "rb-fsevent", :require => RUBY_PLATFORM.include?("darwin") ? "rb-fsevent" : false
end

group :development do
  # Guard
  gem "guard"
  gem "guard-rails", :require => false
  gem "guard-rspec", :require => false

  gem "annotate"
  gem "binding_of_caller"
  gem "better_errors"
  gem "traceroute" # Helps find unused routes and controller actions
  gem "rubocop-rails", :require => false
  gem "rubocop-rake", :require => false
  gem "rubocop-rspec", :require => false
end

group :test do
  gem "apparition", github: "twalpole/apparition"
  gem "factory_bot_rails"
  gem "database_cleaner"
  gem "email_spec"
  gem "launchy"
end
