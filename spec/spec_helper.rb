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
  
  Mongoid.load!("#{File.expand_path('..', __FILE__)}/support/config/mongoid.yml")
  
  config.before :suite do
    Mongoid.configure do |config|
      config.master = Mongo::Connection.new.db('media_magick')
    end
  end
  
  config.after :each do
    Mongoid.master.collections.select { |c| c.name !~ /^system/ }.each(&:drop)
  end
  
  config.after :suite do
    Mongoid.master.connection.drop_database('media_magick')
    Mongoid.master.connection.close
  end
end
