module Api::V1
  class ReadingsController < BaseController
    before_action :authenticate_thermostat!

    def create
      operation = Reading::Create.({reading_attributes: reading_params, thermostat: thermostat})
      if operation.success?
        render json: operation[:result], status: :created
      else
        render json: operation[:errors], status: 422
      end
    end

    private

    def reading_params
      params.permit(:temperature, :humidity, :battery_charge)
    end
  end
end
