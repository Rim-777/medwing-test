require 'sidekiq/web'
Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  api vendor_string: "thermostat tracking", default_version: 1 do
    version 1 do
      cache as: 'v1' do

      end
    end
  end
end
