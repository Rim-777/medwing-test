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
    context 'missing the temperature field' do
      let(:reading_attributes) {Hash[:humidity, 14.7, :battery_charge, 33.18]}

      it 'returns failure' do
        expect(operation.failure?).to be_truthy
      end

      it "doesn't cache a reading attributes" do
        operation
        expect(Rails.cache.fetch(thermostat.household_token)).to be_nil
      end

      it 'adds an error message to operation errors' do
        expect(operation[:errors]).to eq({:temperature=>["is missing"]})
      end

      it "doesn't add a new reading in the database" do
        expect {operation}.to_not change(Reading, :count)
      end
    end

    context 'incorrect value types for the temperature field' do
      context 'string' do
        let(:reading_attributes) {Hash[:temperature, "some string value", :humidity, 14.7, :battery_charge, 33.18]}

        it 'returns failure' do
          expect(operation.failure?).to be_truthy
        end

        it "doesn't cache a reading attributes" do
          operation
          expect(Rails.cache.fetch(thermostat.household_token)).to be_nil
        end

        it 'adds an error message to operation errors' do
          expect(operation[:errors]).to eq({:temperature=>["must be a float"]})
        end

        it "doesn't add a new reading in the database" do
          expect {operation}.to_not change(Reading, :count)
        end
      end

      context 'nil' do
        let(:reading_attributes) {Hash[:temperature, "some string value", :humidity, 14.7, :battery_charge, 33.18]}

        it 'returns failure' do
          expect(operation.failure?).to be_truthy
        end

        it "doesn't cache a reading attributes" do
          operation
          expect(Rails.cache.fetch(thermostat.household_token)).to be_nil
        end

        it 'adds an error message to operation errors' do
          expect(operation[:errors]).to eq({:temperature=>["must be a float"]})
        end

        it "doesn't add a new reading in the database" do
          expect {operation}.to_not change(Reading, :count)
        end
      end
    end
  end
end
