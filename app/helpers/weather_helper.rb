# frozen_string_literal: true

# Extract various metrics from the forecast data returned by the service
module WeatherHelper
  DATE_FORMAT = '%A %m/%d/%Y'
  def day_label(day_data)
    date = day_data['datetime'].to_date
    rdd = relative_date_description(date)
    "#{rdd} #{date.strftime(DATE_FORMAT)}"
  end

  def day_description(day_data)
    "#{day_data['description']}" \
      "  Low: #{fahrenheit(day_data['tempmin'])},  High: #{fahrenheit(day_data['tempmax'])}"
  end

  def fahrenheit(temp)
    "#{temp.round}°F"
  end

  # return Today, Tomorrow or nothing
  def relative_date_description(date)
    today = controller.now.to_date
    if date == today
      'Today,'
    elsif date == today + 1
      'Tomorrow,'
    end
  end
end
