require 'rails_helper'

RSpec.describe Thermostat::Stats::Add  do
  let!(:thermostat) do
    create(:thermostat, address: 'Berlin, Friedrichstrasse st. 77', household_token: 'vtyzdpzkbdmedwing')
  end

  let(:operation) do
    Thermostat::Stats::Add.(operation_params)
  end

  before do
    Rails.cache.write(thermostat.household_token, thermostat_cache)
  end

  context 'initial stats' do
    let(:thermostat_cache) do
      Hash[
          :readings,
          Hash[
              1, Hash[:temperature, 20.0, :humidity, 10.0, :battery_charge, 50.0, :tracking_number, 1]
          ]
      ]
    end

    let(:operation_params){Hash[:tracking_number, 1, :thermostat, thermostat]}

    it 'returns success' do
      expect(operation.success?).to be_truthy
    end

    it 'calls StatsInitInteractor' do
      reading_attributes = Hash[:temperature, 20.0, :humidity, 10.0, :battery_charge, 50.0, :tracking_number, 1]
      expect(StatsInitInteractor).to receive(:new).once.with(reading_attributes).and_call_original
      operation
    end

    it "doesn't call StatsUpdateInteractor" do
      expect(StatsUpdateInteractor).to_not receive(:new)
      operation
    end
  end

  context 'existing stats' do
    let(:thermostat_cache) do
      Hash[
          :readings,
          Hash[
              1, Hash[:temperature, 20.0, :humidity, 10.0, :battery_charge, 50.0, :tracking_number, 1],
              2, Hash[:temperature, 30.0, :humidity, 20.0, :battery_charge, 30.0, :tracking_number, 2]
          ],
          :stats,
          Hash[
              :temperature, Hash[:min, 20.0, :max, 20.0, :average, 20.0],
              :humidity, Hash[:min, 10.0, :max, 10.0, :average, 10.0],
              :battery_charge, Hash[:min, 50.0, :max, 50.0, :average, 50.0]
          ]
      ]
    end

    let(:operation_params){Hash[:tracking_number, 2, :thermostat, thermostat]}

    it 'returns success' do
      expect(operation.success?).to be_truthy
    end

    it 'calls StatsUpdateInteractor' do
      reading_attributes = Hash[:temperature, 30.0, :humidity, 20.0, :battery_charge, 30.0, :tracking_number, 2]
      expect(StatsUpdateInteractor).to receive(:new).once.with(thermostat_cache, reading_attributes).and_call_original
      operation
    end

    it "doesn't call StatsInitInteractor" do
      expect(StatsInitInteractor).to_not receive(:new)
      operation
    end
  end
end