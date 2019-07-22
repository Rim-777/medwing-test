require 'rails_helper'
RSpec.describe Api::V1::ThermostatsController do
  let!(:thermostat) do
    create(:thermostat, address: 'Berlin, Friedrichstrasse st. 77', household_token: 'vtyzdpzkbdmedwing')
  end

  before do
    Rails.cache.clear
    get '/api/thermostats/stats', headers: headers, xhr: true
  end

  describe 'GET stats' do
    let(:headers) {Hash['X-Household-Token', thermostat.household_token]}

    context 'success' do
      context 'stats exist' do
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
          Rails.cache.clear
          Rails.cache.write(thermostat.household_token, thermostat_cache)
          get '/api/thermostats/stats', headers: headers, xhr: true
        end


        it_behaves_like 'SuccessfulResponse'

        it 'returns json according to the schema' do
          expect(response).to match_response_schema('stats')
        end
      end

      context 'stats does not exist' do
        it_behaves_like 'SuccessfulResponse'

        it 'returns null as response body' do
          Rails.cache.clear
          expect(JSON.parse(response.body)).to be_nil
        end
      end
    end

    context 'failure' do
      context 'unauthorized thermostat' do
        let(:headers) {{}}
        it_behaves_like 'UnouthorizedThermostat'
      end
    end
  end
end
