source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.3'
gem 'rails', '~> 5.2.3'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 4.3'
gem "hiredis"
gem "redis", "~> 4.0"
gem 'bootsnap', '>= 1.1.0', require: false
gem 'rack-cors'
gem 'sidekiq'
gem 'sinatra', github: 'sinatra/sinatra', branch: 'master' , require: nil
gem 'trailblazer'
gem "trailblazer-operation"
gem 'api-versions', '~> 1.2', '>= 1.2.1'
gem 'dry-validation', '~> 0.1.0'
gem 'dry-schema', '~> 0.2.0'
gem "hiredis"
gem "redis", "~> 4.0"

group :development, :test do
  gem 'rspec-rails'
  gem 'factory_bot_rails'
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'shoulda-matchers'
  gem 'launchy'
  gem 'database_cleaner'
  gem 'json_spec'
  gem "json_matchers"
  gem 'rails-controller-testing'
  gem 'rspec-mocks'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
