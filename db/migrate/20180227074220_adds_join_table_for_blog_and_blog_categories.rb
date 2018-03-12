class AddsJoinTableForBlogAndBlogCategories < ActiveRecord::Migration[5.1]
  def change
    create_join_table :blog_posts, :blog_categories do |t|
      t.index :blog_post_id
      t.index :blog_category_id
    end
  end
end
