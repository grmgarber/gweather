# frozen_string_literal: true

# The only controller in this application
class WeatherController < ApplicationController
  # helper :weather

  FORECAST_LENGTH_IN_DAYS = 7 # Extended forecast for one week
  def show # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    @zip_code = ZipCode.find_by(postal_code: params[:zip_code])
    if @zip_code.present?
      @data = WeatherService.new.data_for(@zip_code.postal_code, today, today + FORECAST_LENGTH_IN_DAYS - 1)
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream:
                   turbo_stream.replace('results', partial: 'weather/results')
        end
        format.html do
          render 'show'
        end
      end
    else
      @error = 'Specified ZIP Code is invalid'
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream:
                   turbo_stream.replace('results', partial: 'weather/invalid_location')
        end
        format.html do
          render 'show'
        end
      end
    end
  end

  def today
    # We will use the current date several times per request, but calculating it only once per request.
    # Since US spans multiple time zones, we want dates relative to the location's TZ, not the server's TZ.
    @today ||= Time.use_zone(@zip_code.time_zone) { Date.today }
  end
end
