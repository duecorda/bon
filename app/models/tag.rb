class Tag < ActiveRecord::Base

  validates :name, :presence => {message: '꼭 필요합니다'}

  has_many :articles_tags
  has_many :articles, through: :articles_tags

end
