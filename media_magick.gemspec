# -*- encoding: utf-8 -*-
require File.expand_path('../lib/media_magick/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ['Lucas Renan',            'Rodrigo Brancher',    'Rodrigo Pestana']
  gem.email         = ['contato@lucasrenan.com', 'rbrancher@gmail.com', 'rodrigo.pest@gmail.com']
  gem.description   = %q{DEPRECATED. MediaMagick is no longer maintained and is incompatible with Rails 5+, CarrierWave 1+, MiniMagick 4+, and Mongoid 5+. See https://github.com/nudesign/media_magick for alternatives.}
  gem.summary       = %q{DEPRECATED. See https://github.com/nudesign/media_magick for migration paths to Active Storage, CarrierWave 3.x, or Shrine.}
  gem.homepage      = 'https://github.com/nudesign/media_magick'

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = 'media_magick'
  gem.require_paths = ['lib']
  gem.version       = MediaMagick::VERSION
  gem.license       = 'MIT'

  gem.add_dependency 'carrierwave',    '~> 0.9.0'
  # gem.add_dependency 'mongoid',        '>= 2.7.0'
  gem.add_dependency 'plupload-rails', '~> 1.1.0'
  gem.add_dependency 'rails',          '>= 4.0.0'
  gem.add_dependency 'mini_magick',    '~> 3.6.0'

  gem.add_development_dependency 'rake',         '~> 10.1.0'
  gem.add_development_dependency 'rspec-rails',  '~> 2.14.0'
  gem.add_development_dependency 'simplecov',    '~> 0.7.0'
  gem.add_development_dependency 'guard-rspec',  '~> 4.0.0'
  gem.add_development_dependency 'rb-fsevent',   '~> 0.9.0'
end
