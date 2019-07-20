require 'rails_helper'
RSpec.describe Reading::Create do
  let!(:thermostat) do
    create(:thermostat, address: 'Berlin, Friedrichstrasse st. 77', household_token: 'vtyzdpzkbdmedwing')
  end

  let(:operation) do
    Reading::Create.({reading_attributes: reading_attributes, thermostat: thermostat})
  end

  before do
    allow(Rails.cache).to receive(:increment).and_return(1)
    Rails.cache.clear
  end

  context 'valid params' do
    let(:reading_attributes) {Hash[:temperature, 16.5, :humidity, 14.7, :battery_charge, 33.18]}

    it 'returns success' do
      expect(operation.success?).to be_truthy
    end

    it 'caches a reading attributes' do
      operation
      expected_result = Hash[:battery_charge, 33.18, :humidity, 14.7, :temperature, 16.5, :tracking_number, 1]
      expect(Rails.cache.fetch(thermostat.household_token)[:readings][1]).to eq(expected_result)
    end

    it 'assigns a tracking_number as an operation result' do
      expect(operation[:result]).to eq({tracking_number: 1})
    end

    it 'adds a reading in the database' do
      expect {operation}.to change(Reading, :count).by(1)
    end

    it 'adds a reading in the database related to the thermostat' do
      expect {operation}.to change(thermostat.readings, :count).by(1)
    end
  end

  context 'invalid params' do
    context 'temperature' do
      context 'missing field' do
        let(:reading_attributes) {Hash[:humidity, 14.7, :battery_charge, 33.18]}

        it_behaves_like 'InvalidReadingParams' do
          let(:error_context){{temperature:["is missing"]}}
        end
      end

      context 'incorrect value types' do
        context 'string' do
          let(:reading_attributes) {Hash[:temperature, "some string value", :humidity, 14.7, :battery_charge, 33.18]}

          it_behaves_like 'InvalidReadingParams' do
            let(:error_context){{:temperature=>["must be a float"]}}
          end
        end

        context 'nil' do
          let(:reading_attributes) {Hash[:temperature, "some string value", :humidity, 14.7, :battery_charge, 33.18]}

          it_behaves_like 'InvalidReadingParams' do
            let(:error_context){{:temperature=>["must be a float"]}}
          end
        end
      end
    end

    context 'humidity' do
      context 'missing field' do
        let(:reading_attributes) {Hash[:temperature, 16.5, :battery_charge, 33.18]}

        it_behaves_like 'InvalidReadingParams' do
          let(:error_context){{humidity: ["is missing"]}}
        end
      end

      context 'incorrect value types' do
        context 'string' do
          let(:reading_attributes) {Hash[:temperature, 22.3, :humidity, 'some string', :battery_charge, 33.18]}

          it_behaves_like 'InvalidReadingParams' do
            let(:error_context){{humidity: ["must be a float"]}}
          end
        end

        context 'nil' do
          let(:reading_attributes) {Hash[:temperature, 22.3, :humidity, nil, :battery_charge, 33.18]}

          it_behaves_like 'InvalidReadingParams' do
            let(:error_context){{humidity: ["must be a float"]}}
          end
        end
      end
    end

    context 'battery_charge' do
      context 'missing field' do
        let(:reading_attributes) {Hash[:temperature, 16.5, :humidity, 14.7]}

        it_behaves_like 'InvalidReadingParams' do
          let(:error_context){{battery_charge: ["is missing"]}}
        end
      end

      context 'incorrect value types' do
        context 'string' do
          let(:reading_attributes) {Hash[:temperature, 22.3, :humidity, 14.7, :battery_charge, 'some string']}

          it_behaves_like 'InvalidReadingParams' do
            let(:error_context){{battery_charge: ["must be a float"]}}
          end
        end

        context 'nil' do
          let(:reading_attributes) {Hash[:temperature, 22.3, :humidity, 14.7, :battery_charge, nil]}

          it_behaves_like 'InvalidReadingParams' do
            let(:error_context){{battery_charge: ["must be a float"]}}
          end
        end
      end
    end
  end
end
