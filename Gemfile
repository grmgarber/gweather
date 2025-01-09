# frozen_string_literal: true

source 'https://rubygems.org'
ruby '3.3.6'

gem 'bootsnap', require: false
gem 'importmap-rails'
gem 'jbuilder'
gem 'pg', '~> 1.1'
gem 'puma', '>= 5.0'
gem 'rails', '~> 8.0.1'
gem 'sprockets-rails'
gem 'stimulus-rails'
gem 'turbo-rails'
gem 'tzinfo-data', platforms: %i[windows jruby]

group :development, :test do
  gem 'brakeman'
  gem 'debug', platforms: %i[mri windows]
  gem 'rspec-rails', '7.1.0'
end

group :development do
  gem 'rubocop', require: false
  gem 'web-console'
end

group :test do
  gem 'capybara'
  gem 'rails-controller-testing'
  gem 'selenium-webdriver'
  gem 'vcr'
  gem 'webmock'
end
