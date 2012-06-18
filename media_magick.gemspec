# -*- encoding: utf-8 -*-
require File.expand_path('../lib/media_magick/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ['Lucas Renan',            'Rodrigo Brancher',    'Tiago Rafael Godinho']
  gem.email         = ['contato@lucasrenan.com', 'rbrancher@gmail.com', 'tiagogodinho3@gmail.com']
  gem.description   = %q{MediaMagick aims to make dealing with multimedia resources a very easy task – like magic.}
  gem.summary       = %q{MediaMagick aims to make dealing with multimedia resources a very easy task – like magic. It wraps up robust solutions for upload, associate and display images, videos, audios and files to any model in your rails app.}
  gem.homepage      = 'https://github.com/nudesign/media_magick'

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = 'media_magick'
  gem.require_paths = ['lib']
  gem.version       = MediaMagick::VERSION
  
  gem.add_dependency 'carrierwave',    '~> 0.6.0'
  gem.add_dependency 'mongoid',        '>= 2.4'
  gem.add_dependency 'plupload-rails', '~> 1.0.6'
  gem.add_dependency 'rails',          '~> 3.2.0'
  
  gem.add_development_dependency 'bson_ext',    '~> 1.6.0'
  gem.add_development_dependency 'mini_magick', '~> 3.4'
  gem.add_development_dependency 'rake',        '~> 0.9'
  gem.add_development_dependency 'rspec-rails', '~> 2.10.1'
  gem.add_development_dependency 'simplecov',   '~> 0.6.1'
end
