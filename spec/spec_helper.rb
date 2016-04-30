ENV['RACK_ENV'] = 'test'

require File.expand_path('../../boot.rb', __FILE__)

require 'rack/test'

module RSpecMixin
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end
end

RSpec.configure { |c| c.include RSpecMixin }
