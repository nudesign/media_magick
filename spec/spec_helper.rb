require 'media_magick'

RSpec.configure do |config|
  # Remove this line if you don"t want RSpec"s should and should_not
  # methods or matchers
  require 'rspec/expectations'
  
  config.include RSpec::Matchers
  
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
