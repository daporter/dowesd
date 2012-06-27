source "https://rubygems.org"

gem "rails", "3.2.6"
gem "jquery-rails"
gem "bootstrap-sass"
gem "bcrypt-ruby"
gem "will_paginate"
gem "bootstrap-will_paginate"
gem "faker"
gem "slim-rails"
gem "thin"

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem "sass-rails",   "~> 3.2.3"
  gem "coffee-rails", "~> 3.2.2"
  gem "uglifier",     ">= 1.2.3"
end

group :development, :test do
  gem "rspec-rails"
  gem "sqlite3"
  gem "annotate"
end

group :development do
  gem "guard-rspec"
end

group :test do
  gem "capybara"
  gem "rb-fsevent", :require => false
  gem "growl"
  gem "guard-spork"
  gem "spork"
  gem "factory_girl_rails"
end

group :production do
  gem "pg"
end
