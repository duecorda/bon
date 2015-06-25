class Photo < ActiveRecord::Base

  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  index_name "bon-photo-#{Rails.env}"

  store :filesize, accessors: [:original, :thumb], coder: JSON
  store :dimensions, accessors: [:original, :thumb], coder: JSON
  store :positions, accessors: [:left, :top], coder: JSON
  store :details, accessors: [:type, :frames, :mime_type, :shape], coder: JSON
  store :colors,  accessors: [:hex, :rgb, :hsv], coder: JSON

  before_destroy :destroy_assets

  has_many :articles_photos
  has_many :articles, through: :articles_photos

  def title
    self.original_filename
  end

  def url(style = :thumb)
    "/system/photos/#{self.created_at_to_path}/#{style.to_s}_#{self.filename}"
  end

  def path(style = nil)
    dir = "#{Rails.root.to_s}/public/system/photos/#{self.created_at_to_path}"
    FileUtils.mkdir_p dir

    if style.blank?
      dir
    else
      "#{dir}/#{style.to_s}_#{self.filename}"
    end
  end

  def hashkey
    if self.read_attribute(:hashkey).blank?
      self.hashkey = Digest::MD5.hexdigest(self.filename)
    end

    super
  end

  def extname
    File.extname(File.basename(self.original_filename)).downcase
  end

  def self.styles
    [
      { :name => 'main', :size => "600x" },
      { :name => 'section', :size => "480x" },
      { :name => 'se', :size => "320x" },
      { :name => 'hot', :size => "120x" }
    ]
  end

  def attachment=(filedata)
    raise 'filedata is missing.' if filedata.blank?

    if filedata.respond_to? :original_filename
      self.original_filename = filedata.original_filename.to_s.downcase
      _dat = filedata.read
      image = MiniMagick::Image.read(_dat.clone)
    else
      self.original_filename = filedata.to_s.downcase
      _dat = filedata
      _dat = MiniMagick::Image.open(filedata).to_blob
      image = MiniMagick::Image.read(_dat.clone)
    end

    self.force_set_created_at
    self.filename = Time.now.to_f.to_s + self.extname

    image.write self.path(:original)

    self.filesize[:origianl] = image.size
    __original_width = image[:width]
    __original_height = image[:height]
    self.dimensions[:original] = "#{__original_width}x#{__original_height}"
    self.details[:type] = image.type
    self.details[:frames] = image.frames.length
    self.details[:mime_type] = image.mime_type
    self.details[:shape] = if __original_width == __original_height
      "square"
    elsif __original_width > __original_height
      (__original_width / __original_height.to_f < 1.3) ? "wide-square" : "wide"
    elsif __original_width < __original_height
      (__original_height / __original_width.to_f < 1.3) ? "narrow-square" : "narrow"
    end

    image.collapse!
    rate = 755.0 / __original_width
    rate = 1 if rate > 1
    __thumb_width = __original_width * rate
    image.resize __thumb_width

    self.dimensions[:thumb] = "#{image[:width]}x#{image[:height]}"
    image.format "jpg"
    image.write self.path(:thumb)
    self.filesize[:thumb] = image.size
    FileUtils.chmod 0644, self.path(:thumb)

    image.combine_options do |img|
      img.blur "0x4"
      img.fill "black"
      img.colorize "50%"
    end

    image.write self.path(:background)

    # get colors
    info = %x(convert '#{self.path(:thumb)}' -resize 1x1 -depth 8 txt:)
    # info = %x(convert '#{self.path(:thumb)}' -alpha set -channel rgba -colorspace rgb -fuzz 20% -fill transparent -opaque "#ffffff" -resize 1x1 txt:)
    # info = %x(convert '#{self.path(:thumb)}' -alpha set -channel rgba -colorspace rgb -fuzz 20% -fill transparent -opaque "#000000" -resize 1x1 txt:)
    # info = %x(convert '#{self.path(:thumb)}' -alpha set -channel rgba -colorspace rgb -fuzz 15% -fill transparent -opaque "#000000" -fuzz 20% -fill transparent -opaque "#ffffff" -resize 1x1 txt:)
    info = %x(convert '#{self.path(:thumb)}' -alpha set -channel rgba -fuzz 10% -fill transparent -opaque "#000000" -fuzz 10% -fill transparent -opaque "#ffffff" -resize 1x1 txt:)
    self.hex = /\s#([0-9a-f]{6,8})\s/i.match(info).to_a.last
    self.rgb = CustomUtils.hexToRGB(self.hex)
    self.hsv = CustomUtils.rgbToHsv(*self.rgb)

    # get safe background position 
    pos = %x(#{::Rails.root.to_s}/bin/face/face.py #{self.path(:thumb)})
    self.left, self.top = pos.gsub(/[\r\n]/,'').split(/\s/)

    Photo.styles.each do |style|
      _i = MiniMagick::Image.read(_dat.clone)

      _i.resize style[:size]
      
      _i.write self.path(style[:name])
      _i.destroy!
    end

  end

  def force_set_created_at
    self.created_at = Time.now if self.created_at.blank?
  end

  def created_at_to_path
    "#{self.created_at.year}/#{self.created_at.month}/#{self.created_at.day}/#{self.hashkey}"
  end

  def destroy_assets
    self.delete_at_cloud
    FileUtils.rm_rf self.path
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
