ENV['RACK_ENV'] ||= 'development'
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __FILE__)

require 'rubygems'
require 'bundler'

Bundler.require(:default, ENV['RACK_ENV'])

require 'dotenv'
Dotenv.load(".env.#{ENV['RACK_ENV']}")

libs = Dir.glob(File.expand_path('../lib/**/*.rb', __FILE__))
libs.sort.each(&method(:require))

ActiveRecord::Base.establish_connection(
  adapter:  'postgresql',
  host:     ENV['DB_HOST'],
  username: ENV['DB_USERNAME'],
  password: ENV['DB_PASSWORD'],
  database: ENV['DB_NAME'])

require File.expand_path('../app', __FILE__)
