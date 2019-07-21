require 'rails_helper'

RSpec.describe Api::V1::ReadingsController do
  let!(:thermostat) do
    create(:thermostat, address: 'Berlin, Friedrichstrasse st. 77', household_token: 'vtyzdpzkbdmedwing')
  end

  before do
    allow(Rails.cache).to receive(:increment).with(:tracking_number, 1).and_return(1)
    Rails.cache.clear
  end

  describe 'POST create' do
    before {post '/api/readings', params: params, headers: headers, xhr: true}

    context 'success' do
      let(:params) {Hash[:temperature, 16.5, :humidity, 14.7, :battery_charge, 33.18]}

      let(:headers) do
        {'X-Household-Token' => thermostat.household_token}
      end

      it 'returns status :ok' do
        expect(response).to be_successful
      end

      it 'returns json according the schema' do
        expect(JSON.parse(response.body, symbolize_names: true)).to eq Hash[:tracking_number, 1]
      end
    end

    context 'failure' do
      context 'unauthorized thermostat' do
        let(:params) {Hash[:temperature, 16.5, :humidity, 14.7, :battery_charge, 33.18]}
        before {post '/api/readings', params: params, headers: headers, xhr: true}

        it 'returns failure with  the unauthorized status' do
          expect(response.status).to  eq 401
        end
      end
    end
  end
end