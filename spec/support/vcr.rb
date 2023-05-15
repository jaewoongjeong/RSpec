require "vcr"

VCR.configure do |config|
  # Specifying cassettes, or recordings
  config.cassette_library_dir = "#{::Rails.root}/spec/cassettes"
  # Using WebMock to perform the stubbing
  config.hook_into :webmock
  # Ignores requests to localhost
  config.ignore_localhost = true
  config.configure_rspec_metadata!
end
