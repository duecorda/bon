module ApplicationHelper

  def nl2br(str)
    return nil if str.blank?
    str.gsub(/[\n]/, '<br/>').html_safe
  end

  def share_url(service_name, opts = {})
    return nil if service_name.blank?

    opts[:link] ||= request.url
    opts[:text] ||= ""

    uri, link_key, text = case service_name.downcase
      when "twt", "twitter", "tw"
        %w(twitter.com/intent/tweet url text)
      when "fb", "facebook"
        %w(www.facebook.com/sharer/sharer.php u)
      when "gplus", "google"
        %w(plus.google.com/share url)
      when "wb", "weibo", "sina"
        %w(service.weibo.com/share/share.php url)
      when "qq", "qzone"
        %w(sns.qzone.qq.com/cgi-bin/qzshare/cgi_qzshare_onekey url)
      when "rr", "renren"
        %w(share.renren.com/share/buttonshare.do link)
    end

    param = {}
    param[link_key] = escape_javascript(opts[:link])
    param[text] = escape_javascript(opts[:text]) if text.present? && opts[:text]

    ["http://#{uri}", param.to_param].join("?")
  end

  def logged_in?
    @current_user.present?
  end

  def title
    _title = []
    _title.push(@title || "글 쓰기")
    _title.delete_if {|x| x.blank?}
    _title.join(" - ")
  end

  def meta_description
    @meta_description || "글 쓰기"
  end

  def meta_keywords
    if @meta_keywords.present?
      @meta_keywords.split(/\s+/).compact.uniq.collect {|k| k.gsub(/[^0-9a-z가-힣]/i,'')}.delete_if {|x| x.length <= 1}.join(", ")
    else
      "글 쓰기"
    end
  end

  def add_query(options = {})
    specified_url = options.delete(:url) || request.path
    if options.delete(:clear).blank?
      queries = (options.inject(h = {}) {|h,v| h.merge(v[0].to_s => v[1])}).reverse_merge(request.query_parameters)
    else
      queries = (options.inject(h = {}) {|h,v| h.merge(v[0].to_s => v[1])})
    end

    "#{specified_url}?#{(queries.delete_if {|k,v| v.blank?}).to_param}"
  end

  def image_mask(src,w='100%',h='auto',t='50',opts={})
    s = opts.delete(:bgsize) || "cover"
    w = "#{w}px" if w.is_a? Fixnum
    h = "#{h}px" if h.is_a? Fixnum
    image_tag('blank.gif',
      { :style => "width:#{w};height:#{h};background:transparent url('#{src}') no-repeat 50% #{t}% / #{s};" }.merge(opts)
    )
  end

	def dtime_in_words(from_time)
		(distance_of_time_in_words(from_time, Time.now).gsub(/[a-z]+/i) do |m|
		{'years'=>'^년', 'year'=>'^년', 'months'=>'^개월', 'month'=>'^개월', 'days'=>'^일', 'day'=>'^일', 'about'=>'약','second'=>'^초','seconds'=>'^초','minute'=>'^분','minutes'=>'^분','hour'=>'^시간','hours'=>'^시간','a'=>1}[m] end).gsub(/\s\^/,'') + " 전"
	end

  def zerofill(n, l = 2)
    n = 0 if n.blank?
    n.to_s.length < l ? (("0" * (l - n.to_s.length)) + n.to_s) : n
  end

  def htime(dt, opts={})
    return '' if dt.blank?
    divider = opts.delete(:divider) || ":"
    if opts[:simple].present?
      dt.strftime("%H#{divider}%M")
    else
      dt.strftime("%H#{divider}%M#{divider}%S")
    end
  end

  def hdate(dt, opts={})
    return '' if dt.blank?
    divider = opts.delete(:divider) || "."
    if opts[:simple].present?
      dt.strftime("%m#{divider}%d")
    else
      dt.strftime("%Y#{divider}%m#{divider}%d")
    end
  end

  def hdatetime(dt, opts={})
    return '' if dt.blank?
    divider = opts.delete(:divider) || "."
    if opts[:simple].present?
      dt.strftime("%m#{divider}%d %H:%M")
    else
      dt.strftime("%Y#{divider}%m#{divider}%d %H:%M")
    end
  end

  def path_match?(options = {})
    class_name = options.delete(:class_name) || "showing"
    expt_ctrls = options[:controllers].is_a?(Array) ? options.delete(:controllers) : [options.delete(:controllers)]
    expt_actions = (options[:actions].is_a?(Array) ? options.delete(:actions) : [options.delete(:actions)]).compact
    satisfaction = (options.collect {|k,v| ((v.is_a?(NilClass) && !params.keys.include?(k.to_s)) || params[k.to_sym] == v.to_s)}).all?

    if expt_ctrls.include?(params[:controller]) && (expt_actions.blank? || expt_actions.include?(params[:action])) && satisfaction
      class_name
    end
  end

  def flash_message
    fl = flash[:notice]
    flash[:notice] = nil
    "<div class='msg'>#{fl}</div>".html_safe if fl.present?
  end

end
