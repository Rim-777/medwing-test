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

  let(:interactor) {StatsUpdateInteractor.new(thermostat_cache, reading_attributes)}

  describe '#updated_stats_item' do
    it 'updates min value and average' do
      expected_hash = Hash[:min, 10.0, :max, 30.0, :average, 17.5]
      expect(interactor.send(:updated_stats_item,
                             Hash[:min, 20.0, :max, 30.0, :average, 25.0], 10.0)).to eq expected_hash
    end

    it 'updates max value and average' do
      expected_hash = Hash[:min, 20.0, :max, 50.0, :average, 37.5]
      expect(interactor.send(:updated_stats_item,
                             Hash[:min, 20.0, :max, 30.0, :average, 25.0], 50.0)).to eq expected_hash
    end
  end

  let(:reading_attributes) do
    Hash[:temperature, 30.0, :humidity, 20.0, :battery_charge, 30.0]
  end

  describe '#call' do
    it do
      expected_hash = Hash[
          :temperature, Hash[:average, 25, :max, 30, :min, 20],
          :humidity, Hash[:average, 15, :max, 20, :min, 10],
          :battery_charge, Hash[:average, 40, :max, 50, :min, 30]
      ]
      expect(interactor.call).to eq expected_hash
    end
  end
end
