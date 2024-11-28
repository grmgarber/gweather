class AddZipCodesIndexOnPostalCode < ActiveRecord::Migration[8.0]
  def change
    add_index :zip_codes, :postal_code
  end
end
