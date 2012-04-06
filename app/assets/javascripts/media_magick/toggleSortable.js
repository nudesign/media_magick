mediaMagick = {
  toggleSortable: function (parentNode, updateUrl, options) {
    if (parentNode === undefined) { return 'error - no node specified'; }

    var settings = $.extend({
                              'linkSelector': 'a.toggleSortable',
                              'loadData': function () {
                                return {elements: function () { return parentNode.sortable('toArray'); }}
                              },
                              'messagingEngine': 'sticky'
                            }, options);
                          
    if (parentNode.hasClass('sortableActive')) {

      parentNode.sortable('disable');
      parentNode.removeClass('sortableActive');

      if (animation !== undefined) {
        clearInterval(animation);
      }
    
      var currMessage = $(settings.linkSelector).html();
      $(settings.linkSelector).html($(settings.linkSelector).data('message'));
      $(settings.linkSelector).data('message', currMessage);

      $.ajax({
        type: "PUT",
        url: updateUrl,
        data: settings.loadData(),
        beforeSend: function () {
          if (settings.messagingEngine === 'sticky') $.sticky('salvando ordenação…');
        },
        success: function () {
          if (settings.messagingEngine === 'sticky') $.sticky('ordenação salva!');
          parentNode.sortable('destroy');
        },
        error: function () {
          if (settings.messagingEngine === 'sticky') $.sticky('erro ao salvar ordenação…');
          parentNode.sortable('destroy');
        }
      });
    } else {
      parentNode.addClass('sortableActive');
      parentNode.children().removeClass('clearleft');
      parentNode.sortable();
    
      var currMessage = $(settings.linkSelector).html();
      $(settings.linkSelector).html($(settings.linkSelector).data('message'));
      $(settings.linkSelector).data('message', currMessage);
    
      animation = setInterval(function () {
        mediaMagick.shake(parentNode.children());
      }, 100);
    }
  },
  shake: function (nodes) {
    var arr = new Array();
    nodes.each(function (i, el) {
      var el = $(el);

      var rT = Math.floor(Math.random() * 3);
      var rL = Math.floor(Math.random() * 2);

      el.css('margin-top', -rT);
      el.css('margin-bottom', 24 + rT);

      el.css('margin-left', 6 - rL);
      el.css('margin-right', 6 + rL);
    });
  }
}
