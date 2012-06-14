source 'https://rubygems.org'

gem 'rails', '3.2.6'
gem 'haml'
gem 'jquery-rails'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.2'
  gem 'uglifier',     '>= 1.2.3'
end

group :development, :test do
  gem 'rspec-rails'
  gem 'sqlite3'
end

group :development do
  gem 'haml-rails'
  gem 'guard-rspec'
end

group :test do
  gem 'capybara'
  gem 'rb-fsevent', :require => false
  gem 'growl'
  gem 'guard-spork'
  gem 'spork'
end

group :production do
  gem 'pg'
end
