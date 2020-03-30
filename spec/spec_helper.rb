require 'bundler/setup'
require 'byebug'
require 'webmock/rspec'
require 'whiplash_api_v2'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

def fixture(name)
  path = WhiplashApiV2.root.join("spec/support/fixtures/#{name}.json")

  File.read(path) if File.exist?(path)
end
