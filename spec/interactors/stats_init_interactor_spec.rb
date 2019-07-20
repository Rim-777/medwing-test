require 'rails_helper'

RSpec.describe StatsInitInteractor do
  let(:reading_attributes) do
    Hash[:battery_charge, 33.18, :humidity, 14.7, :temperature, 16.5]
  end

  let(:interactor) {StatsInitInteractor.new(reading_attributes)}

  describe '#as_stats' do
    it 'returns a hash with min, max, average keys and with the same value for all keys' do
      expected_hash = Hash[:average, 33.18, :min, 33.18, :max, 33.18]
      expect(interactor.send(:as_stats, reading_attributes[:battery_charge])).to eq expected_hash
    end
  end

  describe '#initial_stats' do
    it 'returns a hash with battery_charge, humidity, temperature keys' do
      expected_hash = Hash[
          :temperature, Hash[:average, 16.5, :min, 16.5, :max, 16.5],
          :humidity, Hash[:average, 14.7, :min, 14.7, :max, 14.7],
          :battery_charge, Hash[:average, 33.18, :min, 33.18, :max, 33.18],
      ]
      expect(interactor.initial_stats).to eq expected_hash
    end
  end
end
