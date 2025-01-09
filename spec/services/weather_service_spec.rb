# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WeatherService do # rubocop:disable Metrics/BlockLength
  let(:seattle_zip_code) { '98109' }
  let(:fair_lawn_zip_code) { '07410' }
  let(:service) { WeatherService.new }
  let(:date) { Date.new(2024, 12, 2) }

  before do
    ZipCode.create(lat: 40.9363, lon: -74.119497, state_abbr: 'NJ', postal_code: fair_lawn_zip_code)
    ZipCode.create(lat: 47.6344, lon: -122.3419, state_abbr: 'WA', postal_code: seattle_zip_code)
  end

  describe '#get_data method' do # rubocop:disable Metrics/BlockLength
    context 'wit Rails cache disabled (RSpec default)' do
      it 'generates the expected output structure' do
        result = VCR.use_cassette('get_data') { service.data_for(seattle_zip_code, date, date + 1) }

        expect(result.keys).to eq(%i[data from_cache error])
      end

      it 'produces expected results' do
        result = VCR.use_cassette('get_data') { service.data_for(seattle_zip_code, date, date + 1) }

        expect(result[:data].slice('latitude', 'longitude', 'resolvedAddress', 'timezone'))
          .to eq({
                   'latitude' => 47.630648,
                   'longitude' => -122.34675,
                   'resolvedAddress' => '98109, USA',
                   'timezone' => 'America/Los_Angeles'
                 })
      end
    end

    context 'with Rails cache enabled' do
      let(:memory_store) { ActiveSupport::Cache.lookup_store(:memory_store) }
      let(:cache) { Rails.cache }
      let(:key) { "zc_#{seattle_zip_code}" }
      let!(:result) do
        VCR.use_cassette('get_data') { service.data_for(seattle_zip_code, date, date + 1) }
      end

      before do
        allow(Rails).to receive(:cache).and_return(memory_store)
        Rails.cache.clear
        Rails.cache.write(key, result[:data])
      end

      it 'will use cached data when zip code matches' do
        result = VCR.use_cassette('get_data') { service.data_for(seattle_zip_code, date, date + 1) }

        expect(result[:from_cache]).to eq(true)
      end

      it 'will not use cached data when zip code does not match' do
        result = VCR.use_cassette('fair_lawn_data') { service.data_for(fair_lawn_zip_code, date, date + 1) }
        expect(result[:from_cache]).to eq(false)
      end
    end
  end
end
