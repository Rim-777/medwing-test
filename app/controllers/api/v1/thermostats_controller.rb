module Api::V1
  class ThermostatsController < BaseController

    def stats
      render json: Thermostat::Stats::Get.({thermostat: thermostat})[:result], status: :ok
    end
  end
end
