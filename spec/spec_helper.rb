require 'simplecov'
SimpleCov.start 'rails'

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../dummy/config/environment.rb',  __FILE__)
require 'rspec/rails'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

RSpec.configure do |config|
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  config.before :suite do
    if Mongoid::VERSION < '3'
      Mongoid.configure do |config|
        config.master = Mongo::Connection.new.db('media_magick')
      end
    else
      Mongoid.connect_to('media_magick')
    end
  end

  config.after :each do
    if Mongoid::VERSION < '3'
      Mongoid.master.collections.select { |c| c.name !~ /^system/ }.each(&:drop)
    else
      Mongoid::Config.purge!
    end
  end
end
