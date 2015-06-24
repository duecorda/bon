if (!RedactorPlugins) var RedactorPlugins = {};

RedactorPlugins.photo = function() {
  return {
    init: function() {
      var button = this.button.add("photo", "사진 등록");
      this.button.setAwesome("photo", "fa-photo");
      this.button.addCallback(button, this.photo.show);
    },
    show: function() {
      var res = $.ajax({url: "/articles/ra_plugins/photo", async: false});
      var template = res["responseText"];
      this.modal.addTemplate('photo', template);
      this.modal.load('photo', '사진 등록', 506);

      this.modal.createCancelButton();

      this.selection.save();
      this.modal.show();

      attachLoaderToForm();
      init_fns();
      $('#photo_uploader').fileupload({
        url: '/photos',
        dataType: 'json',
        paramName: 'photo[attachment][]',
        sequentialUploads: false,
        add: function(e, data) {
          if (/\.(pn|jpe?)?g(if|$)/i.test(data.files[0].name)) {
            data.submit();
          } else {
            alert('png, jpg, gif 만 가능합니다');
          }
        },
        start: function() {
          $('#photo_upload_indicator').addClass("active");
        },
        progressall: function(e, data) {
          var progress = parseInt(data.loaded / data.total * 100, 10);
          var progress_min = $('#photo_upload_indicator .progress').width() / $('#photo_upload_indicator').width() * 100;
          if (progress > progress_min) {
            $('#photo_upload_indicator .progress').css('width', progress + '%');
          }
        },
        done: $.proxy(function(e, data) {
          this.modal.close();
          var images = [];
          $.each(data.result.files, function (index, file) {
            var __image = "<img src='" + file.url + "' class='image' longdesc='" + file.name + "' />";
            images.push(
              '<figure class="obj_container" data-src="' + file.url + '">' +
                __image +
                '<figcaption>' + 
                  file.name +
                '</figcaption>' +
              '</figure><p><br/></p>'
            );
          });
          this.insert.html(images.join(''), false);
          // this.insert.htmlWithoutClean(images.join(''));
          this.selection.restore();
          this.code.sync();
        }, this),
        stop: function(e, data) {
          $('#photo_upload_indicator .progress').css('width', '100%');
          setTimeout(function(){
            $('#photo_upload_indicator').removeClass("active", function() {
              $(this).find('.progress').css('width', '0%');
            });
          }, 500);
        }
      }).prop('disabled', !$.support.fileInput).parent().addClass($.support.fileInput ? undefined : 'disabled');

      $(".image_injector").each($.proxy(function(idx, ijt) {
        $(ijt).on("click", $.proxy(function(event) {
          var _trigger = $(event.target);
          if($(_trigger).parents("ul.matched_photos").length <= 0) {
            return;
          }
          this.modal.close();

          var __cont = $(_trigger).parents("li.matched_photo");
          var __source = $(__cont).find("img.injector");
          var __src = __source.css("background-image").replace(/url|['"\(\)]/g, '');
          // var __src = __source.attr("src").replace(/thumb/, 'article');
          var __caption = __source.attr('longdesc');
          var __image = "<img src='" + __src + "' class='image' longdesc='" + __caption + "' />";

          var _new_html = String() +
            '<figure class="obj_container" data-src="' + __src + '">' +
              __image +
              '<figcaption>' +
                __caption +
              '</figcaption>' +
            '</figure><p><br/></p>'

          this.selection.restore();
          this.insert.html(_new_html, false);
          this.code.sync();
        }, this));
      }, this)); // image_injector

    }
  }
}
