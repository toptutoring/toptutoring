class BlogPost < ApplicationRecord
  belongs_to :user
  
  scope :published, -> { where(published: true) }
  scope :unpublished, -> { where(published: false) }
end
