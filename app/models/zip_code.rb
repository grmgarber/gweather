# frozen_string_literal: true

# This class's table has all US ZIP Codes.
# We use use it to make sure user-specified ZIP Code is valid.
class ZipCode < ActiveRecord::Base
  def with_state_string
    "#{postal_code}, #{state_abbr}"
  end
end
