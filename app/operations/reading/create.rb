require "trailblazer/operation"
class Reading::Create < Trailblazer::Operation
  step :init_entities
  step :validate_reading_attribures
  step :store_reading

  private

  def init_entities(params:)
    @thermostat = params[:thermostat]
    @tracking_number = Rails.cache.increment(:tracking_number, 1)
    @reading_attributes = params[:reading_attributes].merge(tracking_number: @tracking_number).to_h
  end

  def validate_reading_attribures(options)
    validation = NewReadingSchema.(@reading_attributes)
    validation_success = validation.success?
    options[:errors] = validation.errors unless validation_success
    validation_success
  end

  def store_reading(options)
    household_token = @thermostat.household_token
    thermostat_cache = Rails.cache.fetch(household_token) || Hash[:readings, Hash.new]
    thermostat_cache[:readings][@tracking_number] = @reading_attributes
    Rails.cache.write(household_token, thermostat_cache)
    ReadingsDbSavingJob.perform_later(@thermostat, @reading_attributes)
    options[:result] = Hash[:tracking_number, @tracking_number]
  end
end
