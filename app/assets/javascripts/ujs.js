window.popup = function(url, options)  {
  if(!options) options = {}
  var window_id = options.window_id || new Date().getTime()
  var w = options.width || 640
  var h = options.height || 640
  var left = options.left || 400
  var top = options.top || 300
  var scroll = options.scroll || "yes"
  if(options.cb) eval(options.cb)
  var opened_window = window.open(url, window_id, 'width='+w+',height='+h+',left='+left+',top='+top+',scrollbars='+scroll)
  if(opened_window) opened_window.focus()
};

function centerX(w) {
  w = Number(String(w).replace(/[^0-9.]/g,''));
  return ($(document).width() / 2) - (w / 2);
};

function centerY(h) {
  h = Number(String(h).replace(/[^0-9.]/g,''));
  return ($(document).scrollTop() + ($(window).height() / 2)) - (h / 2);
};

function doLoad() {
  var x = centerX(32);
  var y = centerY(32);
  $("#loader").css({'left':x,'top':y});
  $("#loader").show();
};

function doComp() {
  $("#loader").hide();
  init_fns();
};

function doCast(msg) {
  var msg_container = $("<div>").addClass("msg").html(msg);
  $("#flash_message").html(msg_container).show();
};

function disableForms() {
  doLoad();
  $("form:not('.action')").each(function(i, f) {
    $(f).addClass("action");
    var $btn = $(f).find("button.submit");
    if($btn.length > 0) {
      $btn.attr("longdesc", $btn.html());
      $btn.html("wait");
      $btn.attr("disabled", "disabled");
      if($(f).hasClass("breaker")) {
        breakSafeExit();
      }
    }
  });
};

function enableForms(keep_content) {
  doComp();
  $("form.action").each(function(i,f) {
    $(f).removeClass("action");
    var $btn = $(f).find("button.submit");
    if($btn.length > 0) {
      $btn.html($btn.attr("longdesc"));
      $btn.removeAttr("disabled");
      if(!keep_content) {
        f.reset();
      }
    }
  });
};

function resetForms() {
  $("form").each(function (i,f) {
    f.reset();
  });
};

function attachLoaderToForm() {
  $("form:not('.loader_added')").each(function (i,f) {
    $(f).addClass("loader_added");
    $(f).submit(function() {
      disableForms();
    });
  });
  $("button.submit").removeAttr("disabled");
  // enableForms(true);
};


function initFragileElement() {
  $(document).on("mousedown", function(ev) {
    if($(ev.target).prop("tagName").toLowerCase() != "a") {
      if($(ev.target).parents(".fragile").length <= 0) {
        $(".fragile").each(function(i,f) {
          $(f).fadeOut(200);
        });
      }
    }
  });
};

function initSmartFocus() {
  $(".smartfocus").each(function (i,sf) {
    $(sf).blur();
    $(sf).focus();
  });
};

function __resizeTa(ta) {
  window.setTimeout(function() {
    ta.css({height: 'auto'});
    ta.css({height: ta.get(0).scrollHeight + "px"});
  }, 0);
};

function initElasticTextarea() {
  $("textarea.elastic").each(function (i,ta) {
    __resizeTa($(this));
    $(this).scrollTop(0);
    $(this).removeClass("elastic");

    $(this).bind('keydown change cut paste drop', function() {
      __resizeTa($(this));
    });

  });
};
