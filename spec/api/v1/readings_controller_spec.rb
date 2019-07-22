require 'rails_helper'

RSpec.describe Api::V1::ReadingsController do
  let!(:thermostat) do
    create(:thermostat, address: 'Berlin, Friedrichstrasse st. 77', household_token: 'vtyzdpzkbdmedwing')
  end

  let(:headers) {Hash['X-Household-Token', thermostat.household_token]}

  before do
    allow(Rails.cache).to receive(:increment).with(:tracking_number, 1).and_return(1)
    Rails.cache.clear
  end

  describe 'POST create' do
    before {post '/api/readings', params: params, headers: headers, xhr: true}

    context 'success' do
      let(:params) {Hash[:temperature, 16.5, :humidity, 14.7, :battery_charge, 33.18]}
      let(:headers) {Hash['X-Household-Token', thermostat.household_token]}

      it_behaves_like 'SuccessfulResponse'

      it 'returns json according to the schema' do
        expect(response).to match_response_schema('readings_post_success')
      end

      it 'receives the Thermostat::Stats::Add operation' do
        allow(Rails.cache).to receive(:increment).with(:tracking_number, 1).and_return(2)
        expect(Thermostat::Stats::Add).to receive(:call).with(Hash[:thermostat, thermostat, :tracking_number, 2])
        post '/api/readings', params: params, headers: headers, xhr: true
      end
    end

    context 'failure' do
      context 'unauthorized thermostat' do
        let(:params) {Hash[:temperature, 16.5, :humidity, 14.7, :battery_charge, 33.18]}
        before {post '/api/readings', params: params, headers: {}, xhr: true}

        it 'returns failure with  the unauthorized status' do
          expect(response.status).to eq 401
        end

        it 'returns an empty response body' do
          expect(response.body).to be_empty
        end
      end

      context 'invalid field' do
        let(:headers) {Hash['X-Household-Token', thermostat.household_token]}
        before {post '/api/readings', params: params, headers: headers, xhr: true}

        context 'temperature' do
          context 'missing' do
            let(:params) {Hash[:humidity, 14.7, :battery_charge, 33.18]}
            it_behaves_like 'InvalidField' do
              let(:schema) {'invalid_temperature'}
            end
          end

          context 'incorrect type' do
            let(:params) {Hash[:temperature, 'some string', :humidity, 14.7, :battery_charge, 33.18]}
            it_behaves_like 'InvalidField' do
              let(:schema) {'invalid_temperature'}
            end
          end
        end

        context 'humidity' do
          context 'missing' do
            let(:params) {Hash[:temperature, 16.5, :battery_charge, 33.18]}
            it_behaves_like 'InvalidField' do
              let(:schema) {'invalid_humidity'}
            end
          end

          context 'invalid type' do
            let(:params) {Hash[:temperature, 16.5, :humidity, 'some string', :battery_charge, 33.18]}
            it_behaves_like 'InvalidField' do
              let(:schema) {'invalid_humidity'}
            end
          end
        end

        context 'battery_charge' do
          context 'missing' do
            let(:params) {Hash[:temperature, 16.5, :humidity, 14.7]}
            it_behaves_like 'InvalidField' do
              let(:schema) {'invalid_battery_charge'}
            end
          end

          context 'invalid type' do
            let(:params) {Hash[:temperature, 16.5, :humidity, 'some string', :battery_charge, 'some string']}
            it_behaves_like 'InvalidField' do
              let(:schema) {'invalid_battery_charge'}
            end
          end
        end
      end
    end
  end

  describe 'GET show' do
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

    context 'success' do
      before {get "/api/readings/1", headers: headers, xhr: true}

      it_behaves_like 'SuccessfulResponse'

      it 'returns json according to the schema' do
        expect(response).to match_response_schema('readings_get_success')
      end
    end

    context 'failure' do
      before {get "/api/readings/123", headers: headers, xhr: true}

      it 'returns failure with  the not found status' do
        expect(response.status).to eq 404
      end

      it 'returns an empty response body' do
        expect(response.body).to be_empty
      end
    end
  end
end
