# frozen_string_literal: true

require 'rails_helper'

describe WeatherController, type: :controller do # rubocop:disable Metrics/BlockLength
  let!(:seattle_zip_code) { '98109' }
  let!(:fair_lawn_zip_code) { '07410' }
  let!(:brooklyn_zip_code) { '11223' }

  before do
    ZipCode.create(lat: 40.9363, lon: -74.119497, state_abbr: 'NJ', postal_code: fair_lawn_zip_code)
    ZipCode.create(lat: 47.6344, lon: -122.3419, state_abbr: 'WA', postal_code: seattle_zip_code)
  end

  context 'with zip code present in zip_codes table' do
    it 'produces no error', vcr: 'get_data' do
      get :show, params: { zip_code: seattle_zip_code }

      expect(assigns(:error)).to be_nil
    end

    it 'returns a turbo stream', vcr: 'get_data' do
      get :show, params: { zip_code: seattle_zip_code }, as: :turbo_stream

      expect(response.media_type).to eq Mime[:turbo_stream]
    end
  end

  context 'with zip_code missing from zip_codes table' do
    it 'produces an expected error when specified zip code is missing from zip_code table' do
      get :show, params: { zip_code: brooklyn_zip_code }

      expect(assigns(:error)).to eq('Specified ZIP Code is invalid')
    end

    it 'returns a turbo stream' do
      get :show, params: { zip_code: brooklyn_zip_code }, as: :turbo_stream

      expect(response.media_type).to eq Mime[:turbo_stream]
    end
  end
end
