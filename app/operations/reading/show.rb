require "trailblazer/operation"
class Reading::Show < Trailblazer::Operation
  step :get

  private

  def get(options, params:)
    tracking_number = params[:tracking_number].to_i
    thermostat = params[:thermostat]
    options[:result] = Rails.cache.fetch(thermostat.household_token)
                           .try(:fetch, :readings, nil )
                           .try(:fetch, tracking_number, nil )
  end
end
