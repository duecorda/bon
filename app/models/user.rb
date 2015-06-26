class User < ActiveRecord::Base

  validates :login, :presence => {message: '꼭 필요합니다'}, :uniqueness => true
  validates :password, :presence => {message: '꼭 필요합니다'}, :on => :create
  validate :password_validation

  attr_accessor :password_confirmation

  before_save :salting_password

  has_many :articles

  def nick
    "AGENT##{self.id}"
    login
  end

  def self.authenticate(attrs)
    u = find_by_login(attrs[:login])
    u && u.password == Digest::SHA1.hexdigest("#{attrs[:password]}:#{u.salt}") ? u : nil
  end

  protected

    def salting_password
      return unless self.changes.include?('password')
      self.salt = Digest::MD5.hexdigest(Time.now.to_f.to_s)
      self.password = Digest::SHA1.hexdigest("#{self.password}:#{self.salt}")
    end

    def password_validation
      errors.add(:password_confirmation, "비밀번호를 다시 입력해주세요") if (self.new_record? || self.changes.include?('password')) && self.password != @password_confirmation
    end


end
