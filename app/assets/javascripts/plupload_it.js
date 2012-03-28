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
          id:       $container.data('id'),
          relation: $container.data('relation'),
          model:    $container.data('model')
        },
        resize:               settings.resize,
        runtimes:             settings.runtimes,
        silverlight_xap_url:  settings.silverlight_xap_url,
        unique_names:         settings.unique_names,
        url:                  settings.url
      });

      uploader.bind('Init', function(up, params) {
        if ($('#' + settings.container + '-runtimeInfo').length > 0) $('#' + settings.container + '-runtimeInfo').text("Current runtime: " + params.runtime);
        if ($container.find("dt").length > 0 && $container.find("dt").text() == "") $container.find("dt").text($container.attr('id'));
        
        $("a.remove").live('click', function() {
        
          var $attachment = $(this).parents('.attachment');
          
          $.get('/remove', {
            model: $container.data('model'),
            id: $container.data('id'),
            relation: $container.data('relation'),
            relation_id: $attachment.data('id')
          }, function(data) {
            $attachment.remove();
          });
        });
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
              '<dd id="' + file.id + '" class="file">' +
              file.name + ' (' + plupload.formatSize(file.size) + ') <span class="status"></span>' +
              '</dd>'
            ).find("dd:last").append(
              $('<a href="javascript://" class="remove">[x]</a>').bind('click', function () {
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
          $('#' + container + '-' + queue_element).append("<dd class='attachment error'>Error: " + err.code +
          ", Message: " + err.message +
          (err.file ? ", File: " + err.file.name : "") +
          "</dd>");

          up.refresh(); // Reposition Flash/Silverlight
        });

        uploader.bind('FileUploaded', function(up, file, response) {
          $('#' + file.id).addClass('completed');
          $('#' + file.id + " span.status").html("100%");
          $("#" + container + '-' + target_list).append(response.response);
        });
      })(settings.container, settings.queue_element, settings.target_list);

    });

  };
})(jQuery);