class BlogPost < ApplicationRecord
  belongs_to :user
  validates_presence_of :title, :content, :publish_date, :user
  
  scope :published, -> { where(published: true) }
  scope :unpublished, -> { where(published: false) }
end
