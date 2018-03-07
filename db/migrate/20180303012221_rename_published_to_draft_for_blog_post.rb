class RenamePublishedToDraftForBlogPost < ActiveRecord::Migration[5.1]
  def change
    rename_column :blog_posts, :published, :draft
  end
end
