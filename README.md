# MediaMagick [![Build Status](https://secure.travis-ci.org/nudesign/media_magick.png?branch=master)](http://travis-ci.org/nudesign/media_magick) [![Build Status](https://gemnasium.com/nudesign/media_magick.png?travis)](http://gemnasium.com/nudesign/media_magick)

MediaMagick aims to make dealing with multimedia resources a very easy task – like magic. It wraps up robust solutions for upload, associate and display images, videos, audios and files to any model in your rails app.

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
  include MediaMagick::Model

  attachs_many :photos
end

album = Album.create
album.photos.create(photo: params[:file])
album.reload.photos.first.url
album.reload.photos.first.filename
```

#### Custom classes

``` ruby
class Album
  include Mongoid::Document
  include MediaMagick::Model

  attachs_many :photos do
    field :tags, type: Array
  end
end

album = Album.create
album.photos.create(photo: params[:file], tags: ['ruby', 'guru'])
album.reload.photos.first.tags #=> ['ruby', 'guru']
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
