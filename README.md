# README

This is a simple Rails application to display weather information for a user-provided US Zip Code.
We show both current weather, as well as weather for each hour of today and tomorrow.
Data comes from free weather API https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/[location]/[date1]/date2?key=YOUR_API_KEY

Using Ruby 3.3.6 and Rails 7.1.5.

I wanted to use hotwire's turbo stream instead of AJAX, which required rails 7+.
In fact, being a trivial single page application, it does not include a single line of custom Javascript!

We have only one static model (named ZipCode) which is based on zip_codes table.
It is included for the sole purpose of making sure that user-provided ZIP Code actually exists, prior to invoking the API.
If you want to play with the application, populate the development database with a couple of zip_codes records.
See an example in lines 12-13 of spec/services/weather_service_spec.rb of two zip code records for 07410 (Fair Lawn, NJ) and 98109 (Queen Ann in Seattle)
Migrations create only the schema and an index, but do not populate zip_codes table with all US zip_codes, as I felt that
it would be an overkill for this demo.

The application passes all rubocop and brakeman checks.

Run all specs with 
    bundle exec rspec
