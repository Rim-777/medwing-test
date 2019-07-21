module Api::V1
  class ThermostatsController < BaseController
    before_action :authenticate_thermostat!

    def stats
      render json: Thermostat::Stats::Get.({thermostat: thermostat})[:result], status: :ok
    end
  end
end
