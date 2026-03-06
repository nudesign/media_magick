# MediaMagick

> **⚠️ DEPRECATED — No longer maintained.**
>
> This gem has not been updated since April 2014 (v0.4.3) and is **incompatible with Rails 5+, CarrierWave 1+, MiniMagick 4+, and Mongoid 5+**. It will not work in any modern Rails application. See [Alternatives](#alternatives) below.

---

MediaMagick aimed to make dealing with multimedia resources easy — wrapping upload, association, and display of images, videos, and files into simple model macros for Mongoid-backed Rails apps.

## Why it's broken

Several hard incompatibilities accumulated over the years:

- **Rails 5+** removed `render nothing: true`, `render text:`, and `redirect_to :back` — all used internally
- **CarrierWave 1.x** introduced breaking API changes (pinned to `~> 0.9`)
- **MiniMagick 4.x** introduced breaking API changes (pinned to `~> 3.6`)
- **Plupload** (the browser upload library) is largely abandoned
- **Vimeo API v2** was shut down in 2020 — video thumbnail fetching no longer works
- **YouTube thumbnail URLs** changed and now require HTTPS
- All embedded iframes use `http://`, which browsers block as mixed content

## Alternatives

### If you're on ActiveRecord (PostgreSQL, MySQL, SQLite)

Use **[Active Storage](https://guides.rubyonrails.org/active_storage_overview.html)**, built into Rails since 5.2. It handles local and cloud storage (S3, GCS, Azure), image variants, and direct browser uploads with no additional gem required.

```ruby
# model
class Album < ApplicationRecord
  has_many_attached :photos
end

# view (with direct upload)
<%= form.file_field :photos, multiple: true, direct_upload: true %>
```

For image processing with Active Storage, pair it with **[image_processing](https://github.com/janko/image_processing)** (libvips or ImageMagick).

### If you're on Mongoid (MongoDB)

Active Storage does not officially support Mongoid. Your options:

- **[CarrierWave 3.x](https://github.com/carrierwaveuploader/carrierwave)** with the **[carrierwave-mongoid](https://github.com/carrierwaveuploader/carrierwave-mongoid)** adapter. This is the closest spiritual successor — you write uploaders and mount them on models manually, without the macro DSL this gem provided.
- **[Shrine](https://shrinerb.com/)** — a modern, storage-agnostic file attachment library with a Mongoid integration via the `mongoid` plugin. Actively maintained and recommended for new projects.

### For the browser-side uploader

Replace Plupload with one of:

- **[Uppy](https://uppy.io/)** — full-featured, actively maintained, supports direct-to-S3
- **[Filepond](https://pqina.nl/filepond/)** — lightweight and easy to integrate
- Native `<input type="file" multiple>` with drag-and-drop is now well-supported in all browsers without a library

### For video embedding (YouTube / Vimeo)

The built-in `Video::Parser` is broken. Use the **oEmbed** standard instead:

- YouTube: `https://www.youtube.com/oembed?url=<video_url>&format=json`
- Vimeo: `https://vimeo.com/api/oembed.json?url=<video_url>`

Both return an embed HTML snippet without scraping or proprietary APIs.

---

## Original Usage (archived for reference)

The gem provided two model macros for Mongoid documents:

```ruby
class Album
  include Mongoid::Document
  include MediaMagick::Model

  attaches_many :photos, type: :image
  attaches_one  :cover,  type: :image
end
```

This dynamically created embedded document classes with a mounted CarrierWave uploader, a `priority` field for drag-and-drop reordering, and optional video support via YouTube/Vimeo URLs.

---

## License

[MIT License](http://www.opensource.org/licenses/MIT)
