class BlogPost < ApplicationRecord
  before_create :add_slug
  belongs_to :user
  has_and_belongs_to_many :blog_categories
  validates_presence_of :title, :content, :publish_date, :user
  validates :title, uniqueness: true
  
  scope :published, -> { where(published: true) }
  scope :unpublished, -> { where(published: false) }

  def add_slug
    self.slug = self.title.downcase.gsub(" ", "-")
  end
end
