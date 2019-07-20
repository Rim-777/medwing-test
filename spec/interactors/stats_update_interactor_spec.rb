require 'rails_helper'

RSpec.describe StatsUpdateInteractor do
  let!(:thermostat) do
    create(:thermostat, address: 'Berlin, Friedrichstrasse st. 77', household_token: 'vtyzdpzkbdmedwing')
  end

  let(:thermostat_cache) do
    Hash[
        :readings,
        Hash[
            1, Hash[:temperature, 20.0, :humidity, 10.0, :battery_charge, 50.0, :tracking_number, 1],
            2, Hash[:temperature, 30.0, :humidity, 20.0, :battery_charge, 70.0, :tracking_number, 2]
        ],
        :stats,
        Hash[
            :temperature, Hash[:min, 20.0, :max, 30.0, :average, 25.0],
            :humidity, Hash[:min, 10.0, :max, 20.0, :average, 15.0],
            :battery_charge, Hash[:min, 50.0, :max, 70.0, :average, 65.0]
        ]
    ]
  end

  let(:reading_attributes) do
    Hash[:battery_charge, 50.0, :humidity, 10.0, :temperature, 20.0]
  end

  let(:interactor) {StatsUpdateInteractor.new(thermostat_cache, reading_attributes)}

  describe '#updated_stats_item' do

    it 'updates min value and average' do
      expected_hash = Hash[:min, 15.0, :max, 30.0, :average, 20.0]
      expect(interactor.send(:updated_stats_item, Hash[:min, 20.0, :max, 30.0, :average, 25.0], 15.0)).to eq expected_hash
    end

    it 'updates max value and average' do
      expected_hash = Hash[:min, 20.0, :max, 50.0, :average, 37.5]
      expect(interactor.send(:updated_stats_item, Hash[:min, 20.0, :max, 30.0, :average, 25.0], 50.0)).to eq expected_hash
    end
  end
end
