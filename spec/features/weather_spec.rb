# frozen_string_literal: true

require 'rails_helper'

describe 'Getting weather information', type: :feature, js: true do # rubocop:disable Metrics/BlockLength
  let(:seattle_zip_code) { '98109' }
  let(:fair_lawn_zip_code) { '07410' }
  let(:service) { WeatherService.new }
  let(:date) { Date.today }

  before do
    ZipCode.create(lat: 40.9363, lon: -74.119497, state_abbr: 'NJ', postal_code: fair_lawn_zip_code)
    ZipCode.create(lat: 47.6344, lon: -122.3419, state_abbr: 'WA', postal_code: seattle_zip_code)
    # travel_to(Date.new(2025, 1, 8))
    visit root_path
  end

  it 'produces expected page when visiting root URL' do
    expect(page).to have_content 'US ZIP Code'
  end

  it 'can populate zip_code field with a valid US ZIP Code, request weather info and display it' do
    travel_to(Time.zone.parse('8-1-2025 15:00:00'))
    VCR.use_cassette 'sea-feature' do
      fill_in 'zip_code', with: seattle_zip_code
      click_button 'Look up weather'
      expect(page).to have_content 'Current Conditions'
    end
  end

  it 'can populate zip_code field with invalid zip code, request weather info and produce expected error message' do
    fill_in 'zip_code', with: '00001'
    click_button 'Look up weather'

    expect(page).to have_content 'Specified ZIP Code is invalid'
  end

  context 'client-side error handling' do
    it 'shows the expected message when submit button is clicked with empty zip code' do
      click_button 'Look up weather'
      message = page.find('#zip_code').native.attribute('validationMessage')

      expect(message).to eq('Please fill out this field.')
    end

    it 'shows the expected message when submit button is clicked with a zip code field with fewer than 5 characters' do
      fill_in 'zip_code', with: '1234'
      click_button 'Look up weather'
      message = page.find('#zip_code').native.attribute('validationMessage')

      expect(message).to eq('Please use at least 5 characters (you are currently using 4 characters).')
    end

    it ' is unable to enter more than 5 digits in the zip code field' do
      fill_in 'zip_code', with: '12345678'

      zc_field = page.find('#zip_code')
      expect(zc_field.value).to eq('12345')
    end
  end
end
