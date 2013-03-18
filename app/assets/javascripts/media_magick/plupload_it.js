//= require plupload

// optional, only needed if you'd like to use plupload localized
//= require plupload/i18n/pt-br

// optional, but recommended. it sets generic settings like flash url, etc.
//= require plupload.settings

// optional, only if you want to use the jquery integration
//= require jquery.plupload.queue

// optional, choose the ones you'd like to use
//= require plupload.flash
//= require plupload.html4
//= require plupload.html5
//= require plupload.gears

(function($) {

  $.fn.pluploadIt = function (options) {

    var settings = $.extend({
      browse_button:        'pickAttachments', // triggers modal to select files
      container:            'attachmentUploader',
      drop_element:         'dropAttachments',
      flash_swf_url:        '/assets/plupload.flash.swf',
      max_file_size:        '10mb',
      queue_element:        'attachmentQueue',
      resize:               false,
      runtimes:             'gears,html5,flash,browserplus,html4',
      silverlight_xap_url:  '/assets/plupload.silverlight.xap',
      target_list:          'loadedAttachments',
      unique_names:         false,
      upload_button:        'uploadAttachments',
      url:                  '/upload'
    }, options);

    return this.each(function() {

      var $container = $(this);
      settings.container = $container.attr('id');
      var modelAndRelation = $container.data('model') + "-" + $container.data('relation');

      // setup unique ids from classes
      $container.find('.' + settings.browse_button).attr('id', settings.container + '-' + settings.browse_button);
      $container.find('.' + settings.drop_element).attr('id', settings.container + '-' + settings.drop_element);
      $container.find('.' + settings.queue_element).attr('id', settings.container + '-' + settings.queue_element);
      $container.find('.' + settings.target_list).attr('id', settings.container + '-' + settings.target_list);
      $container.find('.' + settings.upload_button).attr('id', settings.container + '-' + settings.upload_button);

      var uploader = new plupload.Uploader({
        browse_button:        settings.container + '-' + settings.browse_button,
        container:            settings.container,
        drop_element:         settings.container + '-' + settings.drop_element,
        flash_swf_url:        settings.flash_swf_url,
        max_file_size:        settings.max_file_size,
        multipart_params: {
          id:                 $container.data('id'),
          relation:           $container.data('relation'),
          model:              $container.data('model'),
          partial:            $container.data('partial') === undefined ? '' : $container.data('partial'),
          partial:            $container.data('loader_partial') === undefined ? '' : $container.data('loader_partial'),
          embedded_in_model:  $container.data('embedded-in-model') === undefined ? '' : $container.data('embedded-in-model'),
          embedded_in_id:     $container.data('embedded-in-id') === undefined ? '' : $container.data('embedded-in-id')
        },
        resize:               settings.resize,
        runtimes:             settings.runtimes,
        silverlight_xap_url:  settings.silverlight_xap_url,
        unique_names:         settings.unique_names,
        url:                  settings.url
      });

      uploader.bind('Init', function(up, params) {
        if ($('#' + settings.container + '-runtimeInfo').length > 0) $('#' + settings.container + '-runtimeInfo').text("Current runtime: " + params.runtime);
      });

      $('#' + settings.container + '-' + settings.upload_button).click(function(e) {
        uploader.start();
        e.preventDefault();
      });

      uploader.init();

      (function (container, queue_element, target_list) {
        uploader.bind('FilesAdded', function(up, files) {
          $.each(files, function(i, file) {
            $('#' + container + '-' + queue_element).append(
              '<li id="' + file.id + '" class="attachment">' +
              file.name + ' (' + plupload.formatSize(file.size) + ') <span class="status"></span>' +
              '</li>'
            ).find("li:last").append(
              $('<a href="javascript://" class="remove btn btn-mini">x</a>').bind('click', function () {
                uploader.removeFile(file);
                $(this).parent().remove();
              })
            );
          });

          up.refresh(); // Reposition Flash/Silverlight
        });

        uploader.bind('UploadProgress', function(up, file) {
          $('#' + file.id + " span.status").html(file.percent + "%");
        });

        uploader.bind('Error', function(up, err) {
          $('#' + container + '-' + queue_element).append("<li class='attachment error'>Error: " + err.code +
          ", Message: " + err.message +
          (err.file ? ", File: " + err.file.name : "") +
          "</li>");

          up.refresh(); // Reposition Flash/Silverlight
        });

        uploader.bind('FileUploaded', function(up, file, response) {
          $('#' + file.id).addClass('completed');
          $('#' + file.id + " span.status").html("100%");
          $("#" + modelAndRelation + '-' + target_list).append(response.response);
        });
      })(settings.container, settings.queue_element, settings.target_list);

    });

  };
})(jQuery);

$(function() {
  // video upload (youtube/vimeo)
  $('.attachmentVideoUploader').on('click', 'a.attachmentVideoUploaderButton', function(){
    var $container  = $(this).parent(".attachmentVideoUploader");
    var $attachment = $(this).parents('.attachment');
    var $videoField = $container.find(".attachmentVideoUploaderField");
    var modelAndRelation = $container.data('model') + "-" + $container.data('relation');

    $.get('/upload', {
        model: $container.data('model'),
        id: $container.data('id'),
        relation: $container.data('relation'),
        relation_id: $attachment.data('id'),
        embedded_in_model: $container.data('embedded-in-model'),
        embedded_in_id: $container.data('embedded-in-id'),
        partial: $container.data('partial') === undefined ? '' : $container.data('partial'),
        video: $videoField.val()
      }, function(data) {
      $('#' + modelAndRelation + '-loadedAttachments').append(data);
      $videoField.val("");
    });
  });

  // attachment removal
  $('.loadedAttachments').on('click', 'a.remove', function() {
    var $container  = $(this).parents('.loadedAttachments');
    var $attachment = $(this).parents('.attachment');

    $.get('/remove', {
      model: $container.data('model'),
      id: $container.data('id'),
      relation: $container.data('relation'),
      relation_id: $attachment.data('id'),
      embedded_in_model: $container.data('embedded-in-model'),
      embedded_in_id: $container.data('embedded-in-id')
    }, function(data) {
      $attachment.remove();
    });
  });
});