class BlogCategory < ApplicationRecord
  has_and_belongs_to_many :blog_posts
  validates :name, uniqueness: true
end
