require 'rails_helper'

RSpec.describe WeatherService do
  before do
    ZipCode.create(lat: 40.9363, lon: -74.119497, state_abbr: 'NJ', postal_code: '07410')
    ZipCode.create(lat: 47.6344, lon: -122.3419, state_abbr: 'WA', postal_code: '98109')
  end

  describe '#get_data' do
    let(:service) { WeatherService.new }
    let(:date) { Date.new(2024, 11, 28) }

    context 'without cache' do
      it 'generates the expected output structure', vcr: { cassette_name: 'get_data' } do
        result = service.data_for('98109', date, date + 1)

        expect(result.keys).to eq(%i[data from_cache error])
      end

      it 'will not use cached data by default', vcr: { cassette_name: 'get_data' } do
        expect(service.data_for('98109', date, date + 1)[:from_cache]).to eq(false)
      end

      it 'produces expected results', vcr: { cassette_name: 'get_data' } do
        result = service.data_for('98109', date, date + 1)

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

    context 'when a cached result exists' do
      # We are going to mock Rails cache
      let(:memory_store) { ActiveSupport::Cache.lookup_store(:memory_store) }
      let(:cache) { Rails.cache }
      let!(:result) { service.data_for('98109', date, date + 1) }

      before do
        allow(Rails).to receive(:cache).and_return(memory_store)
        Rails.cache.clear
      end

      it 'will use cached result', vcr: { cassette_name: 'get_data' } do
        Rails.cache.write('zc_98109', result[:data])
        result2 = service.data_for('98109', date, date + 1)

        expect(result2[:from_cache]).to eq(true)
      end
    end
  end
end
