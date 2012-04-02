# -*- encoding: utf-8 -*-
require File.expand_path('../lib/media_magick/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ['Lucas Renan',            'Rodrigo Brancher',    'Tiago Rafael Godinho']
  gem.email         = ['contato@lucasrenan.com', 'rbrancher@gmail.com', 'tiagogodinho3@gmail.com']
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ''

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = 'media_magick'
  gem.require_paths = ['lib']
  gem.version       = MediaMagick::VERSION
  
  gem.add_dependency 'carrierwave',    '~> 0.6.0'
  gem.add_dependency 'mongoid',        '~> 2.4.0'
  gem.add_dependency 'plupload-rails', '~> 1.0.6'
  gem.add_dependency 'rails',          '~> 3.2.0'
  gem.add_dependency 'mini_magick'
  
  gem.add_development_dependency 'bson_ext',    '~> 1.6.0'
  gem.add_development_dependency 'rake',        '~> 0.9'
  gem.add_development_dependency 'rspec-rails', '~> 2.9.0'
end
