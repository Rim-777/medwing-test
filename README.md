## Thermostats tracking Api
Ruby Rails application for REST API with Trailblazer Operations,
ActiveRecord, RSpec
### Dependencies:
- Ruby 5.2.2
- PostgreSQL
- Redis

### Installation:
- Clone poject
- Run bundler:

 ```shell
 $ bundle install
 ```
- Create database.yml:
```shell
$ cp config/database.yml.sample config/database.yml
```

- Run application:

 ```shell
 $ rails server
 ```
- Run Redis server (in another terminal window):

 ```shell
 $ redis-server
 ```
- Run background engine (in another terminal window):
 
```shell
$ sidekiq
 ```
 
##### Tests:

To execute tests, run following commands:
 
```shell
 $ bundle exec rake db:migrate RAILS_ENV=test #(the first time only)
 $ bundle exec rspec
```

### License

The software is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
