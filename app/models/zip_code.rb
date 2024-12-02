# frozen_string_literal: true

# This class's table has all US ZIP Codes.
# We use use it to make sure user-specified ZIP Code is valid.
class ZipCode < ActiveRecord::Base
  def with_state_string
    "Location: #{state_abbr} #{postal_code}"
  end
end
