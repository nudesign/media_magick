## 0.1.0 (branch: master)

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

* Allow the `attachs_many` to be used in embedded documents

### Deprecations

* `MediaMagick::Model#attachs_many` is deprecated in favor of `attaches_many`.

## 0.0.1 - April 11, 2012

Initial release.
