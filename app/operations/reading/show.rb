require "trailblazer/operation"
class Reading::Show < Trailblazer::Operation
  step :get

  private

  def get(options, params:)
    tracking_number = params[:tracking_number].to_i
    thermostat = params[:thermostat]
    options[:result] = Rails.cache.fetch(thermostat.household_token)
                           .try(:fetch, :readings)
                           .try(:fetch, tracking_number)
  rescue KeyError
    thermostat.readings.find_by_tracking_number(tracking_number)
  end
end
