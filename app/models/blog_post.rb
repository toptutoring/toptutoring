class BlogPost < ApplicationRecord
  before_validation :add_slug
  belongs_to :user
  has_and_belongs_to_many :blog_categories
  validates_presence_of :title, :content, :publish_date, :user
  validates :title, :slug, uniqueness: true
  
  scope :published, -> { where(draft: false) }
  scope :drafts, -> { where(draft: true) }

  def add_slug
    return unless title_changed?
    self.slug = title.downcase
                     .gsub(/[^0-9A-Za-z$-_.+!*'()\s]/, '')
                     .squish
                     .tr(" ", "-")
                     .concat("-#{id}")
  end
end
