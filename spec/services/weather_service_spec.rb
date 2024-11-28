# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WeatherService do # rubocop:disable Metrics/BlockLength
  let(:seattle_zip_code) { '98109' }
  let(:fair_lawn_zip_code) { '07410' }
  let(:service) { WeatherService.new }
  let(:date) { Date.new(2024, 11, 28) }

  before do
    ZipCode.create(lat: 40.9363, lon: -74.119497, state_abbr: 'NJ', postal_code: fair_lawn_zip_code)
    ZipCode.create(lat: 47.6344, lon: -122.3419, state_abbr: 'WA', postal_code: seattle_zip_code)
  end

  describe '#get_data method' do # rubocop:disable Metrics/BlockLength
    context 'wit Rails cache disabled (RSpec default)' do
      it 'generates the expected output structure', vcr: { cassette_name: 'get_data' } do
        result = service.data_for(seattle_zip_code, date, date + 1)

        expect(result.keys).to eq(%i[data from_cache error])
      end

      it 'produces expected results', vcr: { cassette_name: 'get_data' } do
        result = service.data_for(seattle_zip_code, date, date + 1)

        expect(result[:data].slice('latitude', 'longitude', 'resolvedAddress', 'timezone', 'description'))
          .to eq({
                   'latitude' => 47.630648,
                   'longitude' => -122.34675,
                   'resolvedAddress' => '98109, USA',
                   'timezone' => 'America/Los_Angeles',
                   'description' => 'Cooling down with no rain expected.'
                 })
      end
    end

    context 'with Rails cache enabled' do
      let(:memory_store) { ActiveSupport::Cache.lookup_store(:memory_store) }
      let(:cache) { Rails.cache }
      let!(:result) { service.data_for(seattle_zip_code, date, date + 1) } # generate data for placement into the cache
      let(:key) { "zc_#{seattle_zip_code}" }

      before do
        allow(Rails).to receive(:cache).and_return(memory_store)
        Rails.cache.clear
        Rails.cache.write(key, result[:data])
      end

      it 'will use cached data when zip code matches', vcr: { cassette_name: 'get_data' } do
        expect(service.data_for('98109', date, date + 1)[:from_cache]).to eq(true)
      end

      it 'will not use cached data when zip code does not match', vcr: { cassette_name: 'fair_lawn_data' } do
        expect(service.data_for(fair_lawn_zip_code, date, date + 1)[:from_cache]).to eq(false)
      end
    end
  end
end
