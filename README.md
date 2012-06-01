# MediaMagick [![Build Status](https://secure.travis-ci.org/nudesign/media_magick.png?branch=master)](http://travis-ci.org/nudesign/media_magick) [![Build Status](https://gemnasium.com/nudesign/media_magick.png?travis)](http://gemnasium.com/nudesign/media_magick)

MediaMagick aims to make dealing with multimedia resources a very easy task – like magic. It wraps up robust solutions for upload, associate and display images, videos, audios and files to any model in your rails app.

## Installation

Add this line to your application's Gemfile:

    gem 'media_magick'

And then execute:

    $ bundle

## Getting Started

### Model

``` ruby
class Album
  include Mongoid::Document
  include MediaMagick::Model

  attachs_many :photos
end
```

### Controller

``` ruby
def new
  @album = Album.new
end
```

### View

``` erb
<%= attachment_container @album, :files %>
```

### Javascript

``` javascript
$(document).ready(function () {
  $(".attachmentUploader").pluploadIt();
});
```

## Configuring

### Model

``` ruby
class Album
  include Mongoid::Document
  include MediaMagick::Model

  attaches_many :photos, type: 'image'
end

album = Album.create
album.photos.create(photo: params[:file])
album.reload.photos.first.url
album.reload.photos.first.filename
```

#### attaches One

``` ruby
class Album
  include Mongoid::Document
  include MediaMagick::Model

  attaches_one :photo, type: 'image'
end

album = Album.create
album.photo.create(photo: params[:file])
album.reload.photo.url
album.reload.photo.filename
```

#### Custom classes

``` ruby
class Album
  include Mongoid::Document
  include MediaMagick::Model

  attaches_many :photos, type: 'image' do
    field :tags, type: Array
  end
end

album = Album.create
album.photos.create(photo: params[:file], tags: ['ruby', 'guru'])
album.reload.photos.first.tags #=> ['ruby', 'guru']
```

#### Custom uploader

You also need to add `mini_magick` to your **Gemfile** in order to use it for thumbnail generation.

``` ruby
class PhotoUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  version :thumb do
    process :resize_to_fit => [156, 156]
  end
end
```

``` ruby
class Album
  include Mongoid::Document
  include MediaMagick::Model

  attaches_many :photos, type: 'image', uploader: PhotoUploader
end

album = Album.create
album.photos.create(photo: params[:file])
album.reload.photos.first.thumb.url
```

### Form View

``` erb
<%= attachment_container @album, :files %>

<%= attachment_container @album, :files, newAttachments: { class: 'thumbnails' }, loadedAttachments: { class: 'span3' } %>
```

or use a custom layout:

``` html
<%= attachment_container @album, :photos do %>

  <a class="pickAttachments btn" href="javascript://">select files</a>
  <a class="uploadAttachments btn" href="javascript://">upload files</a>

  <ul class="loadedAttachments">
    <%= render :partial => 'photos', :collection => @album.photos, :as => 'photo' %>
  </ul>
<% end %>
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
