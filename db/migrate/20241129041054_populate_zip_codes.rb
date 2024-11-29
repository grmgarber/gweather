# frozen_string_literal: true

# To be fully functional zip_codes table must contain all US zip codes.
# However, for demo purposes we only include two zip codes here.
# If a zip code is not present in the table, the application will say it is invalid.
class PopulateZipCodes < ActiveRecord::Migration[7.1]
  def up
    ZipCode.create(lat: 40.9363, lon: -74.119497, state_abbr: 'NJ', postal_code: '07410')
    ZipCode.create(lat: 47.6344, lon: -122.3419, state_abbr: 'WA', postal_code: '98109')
  end

  def down
    ZipCode.delete_all
  end
end
