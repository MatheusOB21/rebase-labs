ENV['RACK_ENV'] = 'test'

require 'rspec'
require 'rack/test'

RSpec.configure do |conf|
  conf.include Rack::Test::Methods

  conf.before(type: :system) do
    driven_by(:rack_test)
  end
end