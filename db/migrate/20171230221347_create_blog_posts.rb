class CreateBlogPosts < ActiveRecord::Migration[5.1]
  def change
    create_table :blog_posts do |t|
      t.string :title
      t.text :content
      t.date :publish_date
      t.boolean :published, default: false, index: true
      t.references :user, foreign_key: true, index: true

      t.timestamps
    end
  end
end
