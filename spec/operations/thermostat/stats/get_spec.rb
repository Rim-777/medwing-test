require 'rails_helper'

RSpec.describe Thermostat::Stats::Get  do
  let!(:thermostat) do
    create(:thermostat, address: 'Berlin, Friedrichstrasse st. 77', household_token: 'vtyzdpzkbdmedwing')
  end

  let(:operation) do
    Thermostat::Stats::Get.({thermostat: thermostat})
  end

  context 'empty cache' do
    before do
      Rails.cache.clear
    end

    it 'returns failure' do
      expect(operation.failure?).to be_truthy
    end

    it 'returns nil as the result' do
      expect(operation[:result]).to be_nil
    end
  end

  context 'present cache' do
    let(:thermostat_cache) do
      Hash[
          :readings,
          Hash[
              1, Hash[:temperature, 20.0, :humidity, 10.0, :battery_charge, 50.0, :tracking_number, 1],
              2, Hash[:temperature, 30.0, :humidity, 20.0, :battery_charge, 30.0, :tracking_number, 2]
          ],
          :stats,
          Hash[
              :temperature, Hash[:min, 20.0, :max, 30.0, :average, 25.0],
              :humidity, Hash[:min, 10.0, :max, 20.0, :average, 15.0],
              :battery_charge, Hash[:min, 30.0, :max, 50.0, :average, 40.0]
          ]
      ]
    end

    before do
      Rails.cache.write(thermostat.household_token, thermostat_cache)
    end

    it 'returns sucess' do
      expect(operation.success?).to be_truthy
    end

    it 'returns nil as the result' do
      expect(operation[:result]).to eq thermostat_cache[:stats]
    end
  end
end
