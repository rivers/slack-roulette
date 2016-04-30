require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)
task default: :spec

task :environment do
  require File.expand_path('../boot', __FILE__)
end

namespace :db do
  desc 'Migrate the database'
  task migrate: :environment do
    ActiveRecord::Base.logger = Logger.new(STDOUT)
    ActiveRecord::Migration.verbose = true
    ActiveRecord::Migrator.migrate('db/migrate')
  end
end
