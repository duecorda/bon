if (!RedactorPlugins) var RedactorPlugins = {};

RedactorPlugins.removeObj = function() {
  return {
    init: function() {
      var button = this.button.add("removeObj", "사진, 비디오 삭제");
      this.button.setAwesome("removeObj", "fa-remove");
      this.button.addCallback(button, this.removeObj.remove);
    },
    remove: function() {
      var block = this.selection.getBlock();
      if(!block) block = this.selection.getCurrent();
      if(/fig/.test($(block).prop("tagName").toLowerCase())) {
        if(!$(block).hasClass("obj_container")) {
          block = $(block).parents("figure.obj_container");
        }
        block.remove();
      }
    }
  }
}
