class WeatherController < ApplicationController
  def new
    @location = Location.new
  end

  def show
    @location = Location.new(location_params)

    if @location.valid?
      zip_code = ZipCode.find_by(postal_code: @location.zip_code)
      if zip_code.present? && zip_code.state_abbr == @location.state_abbr
        now_date = Date.today
        @data = WeatherService.new.data_for(zip_code.postal_code, now_date, now_date + 1)
        respond_to do |format|
          format.turbo_stream do
            render turbo_stream:
                     turbo_stream.replace("results", partial: "weather/results")
          end
          format.html do
            render 'show'
          end
        end
      end
    else
      if zip_code.present? && zip_code.state_abbr != @location.state_abbr
        @error = 'Incorrect Zip Code for the specified State'
      else
        @error = 'Invalid Zip Code'
      end
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream:
                   turbo_stream.replace("results", partial: "weather/invalid_location")
        end
        format.html do
          render 'show'
        end
      end
    end
  end

  private

  def location_params
    params.require(:location).permit(:city, :state_abbr, :zip_code)
  end
end
