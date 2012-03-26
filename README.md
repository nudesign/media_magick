# MediaMagick [![Build Status](https://secure.travis-ci.org/nudesign/media_magick.png?branch=master)](http://travis-ci.org/nudesign/media_magick) [![Build Status](https://gemnasium.com/nudesign/media_magick.png?travis)](http://gemnasium.com/nudesign/media_magick)

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'media_magick'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install media_magick

## Usage

### Model

``` ruby
class Album
  include Mongoid::Document
  include MediaMagick
  
  attach_many :photos
end

album = Album.new
album.photos.new(photo: params[:file])
album.save!
album.photos.first.url

album.photos.first.filename
album.photos.first.content_type
album.photos.first.width  # only images
album.photos.first.height # only images
```

#### Custom classes

``` ruby
class Album
  include Mongoid::Document
  include MediaMagick
  
  attach_many :photos do
    field :tags, type: Array
  end
end

album = Album.new
album.photos.new(photo: params[:file], tags: ['ruby', 'guru'])
album.save!
album.photos.first.tags
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
