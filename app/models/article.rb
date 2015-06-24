class Article < ActiveRecord::Base

  validates :title, :presence => {message: '제목을 입력하세요'}
  validates :content, :presence => {message: '내용을 입력하세요'}

  belongs_to :user

  has_many :articles_photos
  has_many :photos, through: :articles_photos, source: :photo

  has_many :articles_tags
  has_many :tags, through: :articles_tags, source: :tag

  has_many :comments

  has_many :recommends, as: :recommendable

  before_save :set_published_at, :connect_to_tag, :connect_to_photo

  scope :published, -> { where(published: true) }
  scope :hidden, -> { where.not(published: true) }

  def owned_by?(u)
    u && self.user_id == u.id
  end

  def photo
    self.photos.first
  end
  
  def html_content
    _content = self.content
    doc = Nokogiri::HTML.parse(_content)
    if remove_style
      doc.xpath('//@style').remove
    end

    doc.xpath("//body").children().each do |node|
      next if node.name.downcase != "p"
      if node.inner_html(:encoding => 'utf-8').blank?
        node.inner_html = "<br>"
      end
    end

    doc.xpath("//body").inner_html(:encoding => "utf-8")
  end

  def text_content
    Nokogiri::HTML.parse(self.content).xpath("//body/p").collect {|x| x.text}.delete_if {|y| y.blank?}.join(" ")
  end

  def set_published_at
    return unless self.published?
    return if self.published_at.present?
    self.published_at = Time.now
  end

  def connect_to_tag
    return unless self.changes.include?('hashtags')

    _was = self.hashtags_was.to_s.scan(/(?!#)[^#]+/).collect {|x| x.strip}
    _new = self.hashtags.to_s.scan(/(?!#)[^#]+/).collect {|x| x.gsub(/\s+/, ' ').strip}

    _should_delete = _was - _new
    _should_create = _new - _was

    _should_delete.each do |sd|
      sd.gsub(/^#/,'')
      self.tags.destroy(Tag.find_or_create_by(name: sd))
    end

    _should_create.each do |sc|
      self.tags << Tag.find_or_create_by(name: sc)
    end
  end

  def connect_to_photo
    used = self.photos.collect {|x| x.hashkey}

    images = Nokogiri::HTML.parse(self.content).xpath("//img")
    images.each do |image|
      "/system/photos/2015/6/5/133e0329742d82ec3bde7774b6de56c2/thumb_1433470600.3911176.jpg"

      src = image.attr("src")
      hashkey = /\/system\/photos\/\d{2,4}\/\d{1,2}\/\d{1,2}\/([^\/]+)/.match(src).to_a.last
      next if used.delete(hashkey)
      if exist = Photo.find_by(hashkey: hashkey)
        self.photos << exist
      end
    end

    used.each do |hashkey|
      obsolete = Photo.find_by(hashkey: hashkey)
      self.articles_photos.find_by(photo_id: obsolete.id).destroy
    end
  end

end
