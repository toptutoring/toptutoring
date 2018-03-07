class AddSlugToBlogPosts < ActiveRecord::Migration[5.1]
  def change
    add_column :blog_posts, :slug, :string
    add_index :blog_posts, :title, unique: true
    add_index :blog_posts, :slug, unique: true
  end
end
