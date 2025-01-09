# frozen_string_literal: true

require 'vcr'

VCR.configure do |config|
  config.ignore_hosts '127.0.0.1'
  config.cassette_library_dir = 'spec/vcr_cassettes'
  config.hook_into :webmock
end
