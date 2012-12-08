source "https://rubygems.org"

gem "bcrypt-ruby"
gem "bootstrap-sass"
gem "bootstrap-will_paginate"
gem "faker"
gem "jquery-rails"
gem "sqlite3"
gem "rails"
gem "simple_form"
gem "slim-rails"
gem "thin"
gem "will_paginate"

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem "coffee-rails", "~> 3.2.2"
  gem "sass-rails",   "~> 3.2.3"
  gem "uglifier",     ">= 1.2.3"
end

group :development do
  gem 'awesome_print'
  gem 'pry-rails'
end

group :development, :test do
  gem "rspec-rails"
end

group :test do
  gem "capybara"
  gem "cucumber-rails", require: false
  gem "database_cleaner"
  gem "factory_girl_rails"
  gem "growl"
  gem "rb-fsevent", require: false
end

group :production do
  gem "pg"
end
