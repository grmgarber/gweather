# README

This is a simple Rails application to display weather information for a user-provided US Zip Code.
We show both current weather, as well as weather for each hour of today and tomorrow.
Data comes from free weather API https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/[location]/[date1]/date2?key=YOUR_API_KEY

Using Ruby 3.3.6 and Rails 7.1.5.

I wanted to use hotwire's turbo stream instead of AJAX, which required rails 7+.
In fact, being a trivial single page application, it does not include a single line of custom Javascript.

We have only one static model (named ZipCode) which is based on zip_codes table.
It is included for the sole purpose of making sure that user-provided ZIP Code actually exists, prior to invoking the API.
However, if a zip code is missing from this table, the application will say this zip code is invalid.

We have included only two zip codes in `20241129041054_populate_zip_codes.rb` migration, which should be sufficient for demo purposes:
  - 07410 (Fair Lawn, NJ) 
  - 98109 (Queen Ann in Seattle)

The application passes all rubocop and brakeman checks.

Run all specs with `bundle exec rspec`
