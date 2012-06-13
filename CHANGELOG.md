## Next Release (branch: master)

### Major Changes (Backwards Incompatible)

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
