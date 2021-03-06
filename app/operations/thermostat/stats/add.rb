require "trailblazer/operation"
class Thermostat::Stats::Add < Trailblazer::Operation
  step :init
  step :update_stats

  private

  def init(params:)
    @household_token = params[:thermostat].household_token
    @thermostat_cache = Rails.cache.fetch(@household_token)
    @reading_attributes = @thermostat_cache[:readings][params[:tracking_number]]
  end

  def update_stats(options)
    @thermostat_cache[:stats] = counted_stats
    Rails.cache.write(@household_token, @thermostat_cache)
  end

  def counted_stats
    if @thermostat_cache[:stats]
      StatsUpdateInteractor.new(@thermostat_cache, @reading_attributes).call
    else
      StatsInitInteractor.new(@reading_attributes).call
    end
  end
end
