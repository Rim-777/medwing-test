module Api::V1
  class BaseController < ActionController::API
    attr_reader :thermostat
    before_action :authenticate_thermostat!

    private

    def authenticate_thermostat!
      @thermostat = Thermostat.find_by_household_token!(request.headers['X-Household-Token'])
    rescue ActiveRecord::RecordNotFound
      head :unauthorized
    end
  end
end
