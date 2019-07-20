require "trailblazer/operation"
class Thermostat::Stats::Add < Trailblazer::Operation
  step :init
  step :update_stats

  private

  def init(params:)
    @household_token = params[:thermostat].household_token
    @thermostat_cache = Rails.cache.fetch(@household_token)
    @reading = @thermostat_cache[:readings][params[:tracking_number]]
  end

  def update_stats(options)
    @thermostat_cache[:stats] = counted_stats
    Rails.cache.write(@household_token, @thermostat_cache)
  end

  def counted_stats
    if @thermostat_cache[:stats]
      StatsUpdateInteractor.new(@thermostat_cache, @reading).updated_stats
    else
      StatsInitInteractor.new(@reading).initial_stats
    end
  end
end
