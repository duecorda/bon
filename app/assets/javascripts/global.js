function save_as_private(event) {
  event.preventDefault();
  $("#article_published").val(0);
  $("form.article").submit();
};

function encode_tag(str) {
  return str.replace(/[&<>]/g, function(m) {
    return {"&": "&amp;", "<": "&lt;", ">": "&gt;"}[m];
  });
};

function init_twitter() {
  var twts_count = 0;
  $("a.twitter").each(function(i, candidate_anchor) {
    $(candidate_anchor).removeClass('twitter');
    var href = $(candidate_anchor).attr("href");
    if(/twitter\.com.*[0-9]+$/.test(href)) {
      var twt_width = Math.ceil($(candidate_anchor).parent().width() * 0.5);
      twts_count += 1;

      var twt_quote = $("<blockquote>").
        addClass("twitter-tweet").
        attr("lang", "ko").
        attr("align", "center").
        attr("width", twt_width).
        html("<a href='" + href + "'></a>");
      $(candidate_anchor).parents("blockquote").replaceWith(twt_quote);
    }
  });
  if(twts_count > 0) {
    var twt_script = "<script async src='//platform.twitter.com/widgets.js' charset='utf-8'>";
    $("section.main").append(twt_script);
  }
};

function do_upload(file_input) {
  $("#" + file_input).click();
};

function number_with_delimiter(x) {
  return String(x).replace(/\B(?=(?:\d{3})+(?!\d))/g, ",");
};
function increment(dom_id) {
  var node = $("#" + dom_id);
  $(node).hide();
  var html = $(node).html();
  html = html.replace(/([0-9,]+)/g, function(m) {
    return number_with_delimiter(Number(m.replace(/[^0-9]/g,'')) + 1);
  });
  $(node).html(html).fadeIn();
};
function decrement(dom_id) {
  var node = $("#" + dom_id);
  $(node).hide();
  var html = $(node).html();
  html = html.replace(/([0-9,]+)/g, function(m) {
    return number_with_delimiter(Number(m.replace(/[^0-9]/g,'')) - 1);
  });
  $(node).html(html).fadeIn();
};

function zerofill(n, l) {
  if(!n) n = "0";
  if(!l) l = 2;
  if(String(n).length < l) return new Array(l + 1 - String(n).length).join("0") + n;
  else return n;
};

function animate_scroll_to_element_top(element, duration) {
  if(!duration) {
    duration = 500;
  }
  var newT = $(element).offset().top;
  newT = newT - 50;
  if(newT < 0) {
    newT = 0;
  }
  $("html, body").animate({scrollTop:newT}, duration);
}

function scroll_to_element_top(element_id, duration) {
  if(!duration) {
    duration = 500;
  }
  var newT = $("#" + element_id).offset().top;
  newT = newT - 200;
  if(newT < 0) {
    newT = 0;
  }
  // $("html, body").animate({scrollTop:newT}, duration);
  window.scrollTo(0, newT);
}

function setCookie(name,value,days) {
	if(days) {
		var date = new Date();
		date.setTime(date.getTime()+(days*24*60*60*1000));
		var expires = "; expires="+date.toGMTString();
	}
	else var expires = "";
	document.cookie = name+"="+value+expires+"; path=/";
}

function getCookie(name) {
	var nameKey = name + "=";
	var cookies = document.cookie.split(';');
	for(var i=0;i < cookies.length;i++) {
		var cookie = cookies[i];
		while (cookie.charAt(0)==' ') cookie = cookie.substring(1,cookie.length);
		if (cookie.indexOf(nameKey) == 0) return cookie.substring(nameKey.length,cookie.length);
	}
	return null;
}

function delCookie(name) {
	setCookie(name,"",-1);
}

function init_fns() {
  $("a.fn").each(function(i, a) {
    $(a).removeClass("fn");
    $(a).addClass("fnized");
    var _fn = $(a).attr("data-fn");
    var _args = $(a).attr("data-args") || null;
    $(a).on("click", function(event) {
      event.preventDefault();
      var final_args;
      if(_args) {
        final_args = _args.split(/\s*,\s*/).concat([event]);
      } else {
        final_args = [event]
      }
      eval(_fn).apply(this, final_args);
    });
  });

  $("a.sns_share").each(function(i, a) {
    if($(a).hasClass("share_ready")) {
      return;
    }
    $(a).removeClass("sns_share");
    $(a).addClass("share_ready");
    $(a).on("click", function(e) {
      e.preventDefault();
      var url = $(a).attr("href");
      popup(url, {width:550, height: 300, top:120, window_id:'sns_share'});
    }); 
  });
};

function breakSafeExit() {
    window.onbeforeunload = function() { true; }
};
function safeExit() {
    window.onbeforeunload = function() { return "진행 중인 작업이 있습니다. 페이지를 벗어나시겠습니까?"; }
};

function getID(element) {
  var id;
  var clue = $(element).attr("id")
  var matched = /[0-9]+$/.exec(clue);
  if(matched) {
    id = matched[0];
  }
  return id;
};

$(document).ready(function() {
  init_fns();
});

Roller = function(cb,msec) {
  this.cb = cb;
  this.interval = msec || 2000;
  this.roll();
};
Roller.prototype.roll = function() {
  try {
    this.workerID = window.setInterval(this.cb.bind(this), this.interval);
  } catch(e) { this.stop(); }
};
Roller.prototype.stop = function() {
  window.clearInterval(this.workerID);
  this.workerID = null;
};
Roller.prototype.reset = function() {
  this.stop();
  this.roll();
};

function add_query(options) {
  var protocol = location.protocol;
  var host = location.host;
  var path = location.pathname;

  var query = location.search.substring(1);
  queries = query?JSON.parse('{"' + query.replace(/&/g, '","').replace(/=/g,'":"') + '"}',
                   function(key, value) { return key===""?value:decodeURIComponent(value) }):{}

  $.each(options, function(k,v) {
    queries[k] = v;
  });

  return (protocol + "//" + host + path + "?" + $.param(queries));
};

function hide_flash_message() {
  setTimeout(function() {
    $("#flash_message").fadeOut();
  }, 3500)
};

