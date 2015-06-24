if (!RedactorPlugins) var RedactorPlugins = {};

RedactorPlugins.insertHR = function() {
  return {
    init: function() {
      var button = this.button.add("insertHR", "수평선삽입");
      this.button.setAwesome("insertHR", "fa-minus");
      this.button.addCallback(button, this.insertHR.action);
    },
    action: function(insertMethod) {
      this.modal.close();
      this.selection.restore();
      this.insert.html("<p><br/></p><hr class='sectioning'><p></br></p>", false);
      this.code.sync();
    }
  }
}

