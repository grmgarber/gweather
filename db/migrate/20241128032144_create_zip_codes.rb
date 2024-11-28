class CreateZipCodes < ActiveRecord::Migration[8.0]
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
