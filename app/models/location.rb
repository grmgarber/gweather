class Location
  include ActiveModel::Model
  attr_accessor :city, :state_abbr, :zip_code

  validates :city, presence: true
  validates :state_abbr, presence: true
  validates :zip_code, presence: true, format: { with: /\A\d{5}\z/ }

  def to_s
    "#{city}, #{state_abbr}, #{zip_code}"
  end
end