require_relative 'boot'

require "rails"
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
require "rails/test_unit/railtie"

Bundler.require(*Rails.groups)

module MedwingAssignment
  class Application < Rails::Application
    config.load_defaults 5.2
    config.active_job.queue_adapter = :sidekiq
    config.api_only = true
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'

        resource '*',
                 :headers => :any,
                 :methods => [:get, :post, :delete, :put, :patch]
      end
    end
  end
end
