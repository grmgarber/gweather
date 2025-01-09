# frozen_string_literal: true

require 'rails_helper'

describe 'weather requests', type: :request do # rubocop:disable Metrics/BlockLength
  let!(:seattle_zip_code) { '98109' }
  let!(:fair_lawn_zip_code) { '07410' }
  let!(:brooklyn_zip_code) { '11223' }

  before do
    ZipCode.create(lat: 40.9363, lon: -74.119497, state_abbr: 'NJ', postal_code: fair_lawn_zip_code)
    ZipCode.create(lat: 47.6344, lon: -122.3419, state_abbr: 'WA', postal_code: seattle_zip_code)
    travel_to(Date.new(2025, 1, 8))
  end

  context 'with zip code present in zip_codes table' do
    before do
      VCR.use_cassette('sea-request') do
        get weather_path(format: :turbo_stream), params: { zip_code: seattle_zip_code }
      end
    end

    it 'returns a turbo stream with status 200' do
      expect(response.status).to eq 200
      expect(response.media_type).to eq Mime[:turbo_stream]
    end

    it 'produces expected results' do
      expect(response).to render_template(layout: false)
      expect(response.body).to include('<turbo-stream action="replace" target="results">')
      expect(response.body).to include('<h4>Location: WA 98109</h4>')
      expect(response.body).to include('<h4>Location: WA 98109</h4>')
      expect(response.body).to include('<div class="heading">Current Conditions</div>')
    end
  end

  context 'with zip_code missing from zip_codes table' do
    before do
      VCR.use_cassette('sea-request') do
        get weather_path(format: :turbo_stream), params: { zip_code: brooklyn_zip_code }
      end
    end

    it 'produces an expected error when specified zip code is missing from zip_code table' do
      expect(assigns(:error)).to eq('Specified ZIP Code is invalid')
    end

    it 'returns a turbo stream' do
      expect(response.media_type).to eq Mime[:turbo_stream]
    end
  end
end
