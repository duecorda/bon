class Embed < ActiveRecord::Base
  class EmbedError < StandardError; end

  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  index_name "bon-embed-#{Rails.env}"

  def source=(__source)
    raise EmbedError, "코드없음" if __source.blank?
    __source.strip!

    # Youtube 
    if /youtu\.?be(\.com)?/.match(__source)
      ytkey ||= /\/embed\/([-_a-zA-Z0-9]+)/i.match(__source).to_a.last
      ytkey ||= /\/v\/([-_a-zA-Z0-9]+)/i.match(__source).to_a.last
      ytkey ||= /v=([-_a-zA-Z0-9]+)/i.match(__source).to_a.last
      ytkey ||= /youtu\.be\/([-_a-zA-Z0-9]+)/i.match(__source).to_a.last

      if ytkey.blank?
        raise EmbedError, "코드오류 (youtube)"
      else
        self.youtube_key = ytkey
        self.code = "<iframe data-verified='redactor' data-redactor-tag='iframe' id='ytplayer' type='text/html' width='755' height='476' src='https://www.youtube.com/embed/#{ytkey}' frameborder='0' webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>"
        self.url = "http://www.youtube.com/watch?v=#{ytkey}"
        self.cover = "http://i1.ytimg.com/vi/#{ytkey}/hqdefault.jpg"

        begin
          req_url = URI.escape("https://www.googleapis.com/youtube/v3/videos?id=#{ytkey}&key=#{YOUTUBEAPIKEY}&part=snippet&fields=items(snippet/title,snippet/description,snippet/thumbnails)")
          res = Typhoeus.get(req_url)
          snippet = JSON.parse(res.body.force_encoding(Encoding::UTF_8))
          self.title = snippet["items"][0]["snippet"]["title"]
          self.content = snippet["items"][0]["snippet"]["description"]
          self.cover = snippet["items"][0]["snippet"]["thumbnails"]["high"]["url"]
        rescue
          #
        end
      end
    elsif /vimeo\.com/.match(__source)
      vmkey ||= /vimeo\.com\/([0-9]+)/.match(__source).to_a.last
      vmkey ||= /vimeo\.com\/video\/([0-9]+)/.match(__source).to_a.last
      vmkey ||= /clip_id=([0-9]+)/.match(__source).to_a.last
      if vmkey.blank?
        raise EmbedError, "코드오류 (vimeo)"
      else
        self.vimeo_key = vmkey
        self.code = "<iframe src='//player.vimeo.com/video/#{vmkey}' width='755' height='476' frameborder='0' webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>"
        self.url = "http://vimeo.com/#{vmkey}"

        begin
          req_url = "http://vimeo.com/api/oembed.json?url=http://vimeo.com/#{vmkey}"
          res = Typhoeus.get(req_url)
          oembed = JSON.parse(res.body.force_encoding(Encoding::UTF_8))
          self.title = oembed["title"]
          self.content = oembed["description"]
          self.cover = oembed["thumbnail_url"]
        rescue
          #
        end
      end
    elsif /twitter\.com.*status/.match(__source)
      twitter_url = /https?:\/\/twitter.com.*status[^\s'">]+/.match(__source).to_s

      self.fake_key = twitter_url
      self.url = twitter_url
      self.code = "<blockquote><a href='#{twitter_url}' class='twitter'>Twitter</a></blockquote>"
    else
      doc = Nokogiri::HTML.parse(__source)
      node = doc.at("//iframe") rescue nil
      node ||= doc.at("//embed") rescue nil
      raise EmbedError, "코드오류 (embed or iframe)" if node.blank?

      node["width"] = 755
      node["height"] = 476
      node["autostart"] = false
      node["autoplay"] = false
      node["src"] = node["src"].to_s.gsub(/isautoplay=true/i, 'isAutoPlay=false')
      node["flashvars"] = node["flashvars"].to_s.gsub(/auto(start|play)=(true|1)/i, 'auto\1=false')

      self.fake_key = Digest::MD5.hexdigest("#{node["src"].to_s}#{node["flashvars"].to_s}")
      self.code = node.to_s
      self.url = __source.match(/https?:\/\/([^\/]+)/).to_a.last.to_s.split(/\./)[-3..-1].join(".")
    end
  end

  ###
  ### Elasticsearch 
  ###
  settings index: { number_of_shards: 1 } do
#    mapping dynamic: 'false' do
#      indexes :title
#    end
  end

  def self.reindex!
    self.__elasticsearch__.create_index! force: true
    self.__elasticsearch__.refresh_index!
    self.import
  end

end
