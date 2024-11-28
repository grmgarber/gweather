# frozen_string_literal: true

# The only controller in this application
class WeatherController < ApplicationController
  def new
    # @location = Location.new
  end

  def show # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    @zip_code = ZipCode.find_by(postal_code: params[:zip_code])
    if @zip_code.present?
      now_date = Date.today
      @data = WeatherService.new.data_for(@zip_code.postal_code, now_date, now_date + 1)
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

  # private
  #
  # # def location_params
  #   params.require(:location).permit(:city, :state_abbr, :zip_code)
  # end
end
