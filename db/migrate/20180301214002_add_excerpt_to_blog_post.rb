class AddExcerptToBlogPost < ActiveRecord::Migration[5.1]
  def change
    add_column :blog_posts, :excerpt, :text
  end
end
