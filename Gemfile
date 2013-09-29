# encoding: utf-8

source 'https://rubygems.org'

ruby '1.9.3'

gem 'bcrypt-ruby', '~> 3.0.0'
gem 'bootstrap-sass'
gem 'bootstrap-will_paginate'
gem 'faker'
gem 'jquery-rails'
gem 'rails', '~> 3.2'
gem 'simple_form'
gem 'slim-rails'
gem 'thin'
gem 'unicorn'
gem 'will_paginate'

group :assets do
  gem 'coffee-rails'
  gem 'sass-rails'
  gem 'uglifier'
end

group :development do
  gem 'annotate'
  gem 'awesome_print'
  gem 'pry-rails'
end

group :development, :test do
  gem 'sqlite3'
  gem 'rspec-rails', '~> 2.12'
end

group :test do
  gem 'capybara'
  gem 'factory_girl_rails'
  gem 'shoulda-matchers'
  gem 'simplecov', :require => false
end

group :production do
  gem 'pg'
end
