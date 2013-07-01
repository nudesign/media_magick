## Next Release (branch: v0.4)

* support rails 4

## 0.3.1 - July 1, 2013

  * bug fix: removes image from file system after remove document

## 0.3.0 - July 1, 2013

### Helpers

* `attachment_container` and `attachment_container_for_video` are deprecated. please use `attachment_uploader` (for upload) and `attachment_loader` for rendering resources

* new option for custom partial render after upload `attachment_uploader(model, relation, type, {loader_partial: 'path/to/custom_loader'})`

### Libraries

* carrierwave ~> 0.8

* mongoid >= 3.0

* mini_magick ~> 3.5 (now is a gem dependency)

* updates jquery - 1.9.1

### Bugs found

* attaches_many :videos - 'videos' is a reserved word

* attachments for models inside a module [fixed]


## branch v0.3 untill 12.2012

Helpers:

* `attachment_container_for_video` doesn't render resources (images or videos)

* updates carrierwave (~> 0.7.0)

* store image dimensions in mongodb to avoid unnecessary file reads (when call method size - lazy behaviour)

### Resolved Issues

* #2 - video upload for attaches one relation


## 0.1.1 - October 11, 2012

## 0.2.0 - November 19, 2012

### Improvements

* Update carrierwave to 0.7.0.

## 0.1.1 - October 11, 2012

## 0.2.0 - November 19, 2012

### Improvements

* Update carrierwave to 0.7.0.

## 0.1.1 - October 11, 2012

### Improvements

* Adding support to videos.

Model:

``` rb
class Album
  include Mongoid::Document
  include MediaMagick::Model

  attaches_many :medias, allow_videos: true
end

album = Album.create
album.medias.create(video: 'youtube.com/watch?v=FfUHkPf9D9k')
album.reload.photos.first.url
album.reload.photos.first.filename

# Specific methods

album.reload.medias.first.type   #=> 'video'
album.reload.medias.first.video  #=> 'youtube.com/watch?v=FfUHkPf9D9k'
album.reload.medias.first.source #=> <iframe>youtube video</iframe>
```

View:

``` ruby
attachment_container_for_video @album, :files
```

* Adding support to Mongoid 3.

### Major Changes (Backwards Incompatible)

* Media Magick no longer supports Ruby 1.8.7.

* Adding the `as` option in `attachment_container` to define the partial to be rendered

After:

``` rb
class Album
  include Mongoid::Document
  include MediaMagick::Model

  attaches_many :files, type: 'file'
end
```

Now:

``` rb
attachment_container @album, :files, as: 'file'
```

* Now **newAttachments** and **loadedAttachments** are options for `attachment_container`

After:

``` rb
attachment_container @album, :photos, { class: 'thumbnails' }, { class: 'span3' }, partial: 'albums/photo'

# without newAttachments and loadedAttachments
attachment_container @album, :photos, {}, {}, partial: 'albums/photo'
```

Now:

``` rb
attachment_container @album, :photos, newAttachments: { class: 'thumbnails' }, loadedAttachments: { class: 'span3' }, partial: 'albums/photo'

# without newAttachments and loadedAttachments
attachment_container @album, :photos, partial: 'albums/photo'
```

* `MediaMagick::Model#attachs_many` has been removed in favor of `attaches_many`.

* Removing related relations and the ability to create an image without a father.

### Resolved Issues

* Javascript returning undefined instead of "" prevents attachments from working at embedded documents

## 0.1.0 - June 11, 2012

### Improvements

* Implementation of `attaches_one`

``` ruby
class Album
  include Mongoid::Document
  include MediaMagick::Model

  attaches_one :photo
end

album = Album.create
album.photo.create(photo: params[:file])
album.reload.photo.url
album.reload.photo.filename
```

* `attachment_container` can personalize the partial

``` erb
<%= attachment_container @album, :photos, {}, {}, partial: 'albums/photo' %>
```

* Allows to create an image without a father in related relations

``` ruby
class Album
  include Mongoid::Document
  include MediaMagick::Model

  attaches_many :photos, :relation => :referenced
end

album = Album.new
photo = album.photos.create(photo: params[:file])
```

* Allow the `attaches_many` to be used in embedded documents

``` erb
<%= attachment_container @album, :photos, {}, {}, embedded_in: @album.artist %>
```

### Deprecations

* `MediaMagick::Model#attachs_many` is deprecated in favor of `attaches_many`.

## 0.0.1 - April 11, 2012

Initial release.
