class ReadingsDbSavingJob < ApplicationJob
  queue_as :default

    def perform(thermostat, attributes)
      thermostat.readings.create(attributes)
    end
end
