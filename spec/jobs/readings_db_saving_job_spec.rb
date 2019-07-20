require 'rails_helper'

RSpec.describe ReadingsDbSavingJob, type: :job do
  let!(:thermostat) do
    create(:thermostat, address: 'Berlin, Friedrichstrasse st. 77', household_token: 'vtyzdpzkbdmedwing')
  end

  let(:reading_attributes) do
    Hash[:battery_charge, 33.18, :humidity, 14.7, :temperature, 16.5, :tracking_number, 1]
  end

  it 'adds a reading in the database' do
    expect {ReadingsDbSavingJob.perform_later(thermostat, reading_attributes)}.to change(Reading, :count).by(1)
  end

  it 'adds a reading in the database related to the thermostat' do
    expect {ReadingsDbSavingJob.perform_later(thermostat, reading_attributes)}.to change(thermostat.readings, :count).by(1)
  end
end
