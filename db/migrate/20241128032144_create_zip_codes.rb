# frozen_string_literal: true

# Create zip_codes table
class CreateZipCodes < ActiveRecord::Migration[7.1]
  def change
    create_table :zip_codes do |t|
      t.string :time_zone
      t.float :lat
      t.float :lon
      t.string :state_abbr
      t.string :postal_code
    end
  end
end
