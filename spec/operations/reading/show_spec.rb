require 'rails_helper'
RSpec.describe Reading::Show do
  let!(:thermostat) do
    create(:thermostat, address: 'Berlin, Friedrichstrasse st. 77', household_token: 'vtyzdpzkbdmedwing')
  end

  let!(:reading) do
    create(
        :reading,
        tracking_number: 1,
        temperature: 16.5,
        humidity: 14.7,
        battery_charge: 33.18,
        thermostat: thermostat
    )
  end

  before do
    Rails.cache.clear
    Rails.cache.write(
        thermostat.household_token,
        Hash[:readings,
             Hash[reading.tracking_number,
                  reading.to_json(only: [:tracking_number, :temperature, :humidity, :battery_charge])
             ]
        ])

  end

  context 'the reading exists' do
    let(:operation) do
      Reading::Show.({tracking_number: 1, thermostat: thermostat})
    end

    it 'returns success' do
      expect(operation.success?).to be_truthy
    end

    it_behaves_like 'Cacheble'

    it 'assigns a reading attributes as an operation result' do
      expect(operation[:result]).to eq("{\"tracking_number\":1,\"temperature\":16.5,\"humidity\":14.7,\"battery_charge\":33.18}")
    end
  end

  context 'required reading does not exists' do
    let(:operation) do
      Reading::Show.({tracking_number: 355, thermostat: thermostat})
    end

    it 'returns failure' do
      expect(operation.failure?).to be_truthy
    end

    it_behaves_like 'Cacheble'

    it 'assigns a reading attributes as an operation result' do
      expect(operation[:result]).to be_nil
    end
  end
end