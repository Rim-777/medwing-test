require "trailblazer/operation"
class Thermostat::Stats::Get < Trailblazer::Operation
  step :perform

  private

  def perform(options, params:)
    options[:result] = Rails.cache.fetch(params[:thermostat].household_token)[:stats]
  end
end
