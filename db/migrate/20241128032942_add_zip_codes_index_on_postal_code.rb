class AddZipCodesIndexOnPostalCode < ActiveRecord::Migration[7.1]
  def change
    add_index :zip_codes, :postal_code
  end
end
