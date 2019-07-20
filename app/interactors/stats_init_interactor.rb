class StatsInitInteractor

  def initialize(reading_attributes)
    @reading_attributes = reading_attributes
  end

  def initial_stats
    Hash[
        :temperature, as_stats(@reading_attributes[:temperature]),
        :humidity, as_stats(@reading_attributes[:humidity]),
        :battery_charge, as_stats(@reading_attributes[:battery_charge]),
    ]
  end

  private

  def as_stats(attributes)
    min = max = average = attributes
    Hash[:min, min, :max, max, :average, average]
  end
end
