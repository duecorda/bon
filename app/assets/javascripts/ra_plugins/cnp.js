if (!RedactorPlugins) var RedactorPlugins = {};

RedactorPlugins.cnp = function() {
  return {
    init: function() {
      var button = this.button.add("cnp", "복붙");
      this.button.setAwesome("cnp", "fa-file-text-o");
      this.button.addCallback(button, this.cnp.show);
    },
    show: function() {
      var res = $.ajax({url: "/articles/ra_plugins/cnp", async: false});
      var template = res["responseText"];
      this.modal.addTemplate('cnp', template);
      this.modal.load('cnp', '텍스트 붙여넣기', 400);

      // this.modal.createCancelButton();

      var button = this.modal.createActionButton('붙여넣기');
      button.on('click', this.cnp.insert);

      this.selection.save();
      this.modal.show();
    },
    insert: function() {
      this.modal.close();

      var _text = $('#cnp-textarea').val();
      var blocks = _text.replace(/(^[\r\n\s\t]+$)+/gm,'').split(/[\r\n]/);
      var _html = $.map(blocks, function(b, i) {
        var _content = b == "" ? "<br />" : b;
        return "<p>" + encode_tag(_content) + "</p>";
      });

      this.selection.restore();
      this.insert.html(_html.join(""), false);
      this.code.sync();
    }
  }
}
