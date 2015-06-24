function image_snapper(editor, image) {

  var container = image.parents("figure.obj_container");

  var res = $.ajax({url: "/articles/ra_plugins/image_snapper", async: false});
  var template = res["responseText"];
  editor.modal.addTemplate('image_snapper', template);
  editor.modal.load('image_snapper', '이미지 포지션 변경', 400);

  editor.modal.createCancelButton();
  // editor.selection.save();
  editor.modal.show();

  $("i.image_snap_to_left").on("click", function() {
    container.removeClass("align_right");
    container.addClass("align_left");
    editor.image.hideResize();
    editor.modal.close();
    // editor.observe.images();
    editor.code.sync();
  });

  $("i.image_snap_to").on("click", function() {
    container.removeClass("align_left");
    container.removeClass("align_right");
    editor.image.hideResize();
    editor.modal.close();
    // editor.observe.images();
    editor.code.sync();
  });

  $("i.image_snap_to_right").on("click", function() {
    container.removeClass("align_left");
    container.addClass("align_right");
    editor.image.hideResize();
    editor.modal.close();
    // editor.observe.images();
    editor.code.sync();
  });

};
