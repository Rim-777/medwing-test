class StatsUpdateInteractor

  def initialize(thermostat_cache, reading_attributes)
    @thermostat_cache = thermostat_cache
    @reading_attributes = reading_attributes
  end

  def call
    stats = @thermostat_cache[:stats]
    stats.each do |key, value|
      stats[key] = updated_stats_item(value, @reading_attributes[key])
    end
    stats
  end

  private

  def updated_stats_item(stats_item, new_value)
    reading_amount = @thermostat_cache[:readings].size
    stats_item.each do |field, current_value|
      stats_item[field] = if field == :min
                            current_value <= new_value ? current_value : new_value
                          elsif field == :max
                            current_value >= new_value ? current_value : new_value
                          else
                            ((current_value * (reading_amount - 1) + new_value) / reading_amount).to_f.round(10)
                          end
    end
  end
end
