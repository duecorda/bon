if (!RedactorPlugins) var RedactorPlugins = {};

RedactorPlugins.insertP = function() {
  return {
    init: function() {
      var button = this.button.add("insertP", "단락삽입");
      this.button.setAwesome("insertP", "fa-terminal");
      this.button.addCallback(button, this.insertP.action);
    },
    action: function(insertMethod) {
      if(!insertMethod) insertMethod = "insertAfter";
      var ancients = [];
      var block = this.selection.getBlock();
      if(block) {
        while(!$(block).hasClass("redactor-editor") && $(block).prop("tagName").toLowerCase() != "body") {
          ancients.push(block);
          block = $(block).parent();
        }
        var paragraph = ancients.pop();
        var new_block = $("<p></p>").html("<br/>");
        $(new_block)[insertMethod]($(paragraph));
        this.caret.setStart(new_block);
      }
    }
  }
}
