if (!RedactorPlugins) var RedactorPlugins = {};

RedactorPlugins.embed = function() {
  return {
    init: function() {
      var button = this.button.add("embed", "임베드");
      this.button.setAwesome("embed", "fa-youtube-play");
      this.button.addCallback(button, this.embed.show);
    },
    show: function() {
      var res = $.ajax({url: "/articles/ra_plugins/embed", async: false});
      var template = res["responseText"];
      this.modal.addTemplate('embed', template);
      this.modal.load('embed', '임베드', 506);

      this.selection.save();
      this.modal.show();

      attachLoaderToForm();
      init_fns();
      $(".embed_injector").each($.proxy(function(idx, vjt) {
        $(vjt).on("click", $.proxy(function(event) {
          var _trigger = $(event.target);
          if($(_trigger).parents("ul.matched_embeds").length <= 0) {
            return;
          }
          this.modal.close();

          var __cont = $(_trigger).parents("li.matched_embed");
          var __source = $(__cont).find("img.injector");
          var __code = __code = $('<textarea/>').html($(__source).attr("longdesc")).text();
          var __caption = $(__cont).find("figcaption").text() || "embed"

          var __new_html = String() +
            '<figure class="obj_container embed">' +
              __code +
              '<figcaption>' +
                __caption +
              '</figcaption>' +
            '</figure><p><br/></p>';

          this.selection.restore();
          this.insert.html(__new_html, false);
          this.code.sync();

          if(/twitter\.com.*?status/i.test(__code)) {
            init_twitter();
          }
        }, this));
      }, this)); // youtube_injector
    }
  }
}
