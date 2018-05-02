SitemapGenerator::Sitemap.default_host = ENV.fetch("WWW_HOST")

# Usage: add(path, options={})
#        (default options are used if you don't specify)
#
# Defaults: :priority => 0.5, :changefreq => 'weekly',
#           :lastmod => Time.now, :host => default_host

SitemapGenerator::Sitemap.create do
  page_files = Dir.glob(Rails.root
                             .join("app", "views", "www", "pages")
                             .to_s
                             .concat("/*"))
  page_files.map! { |file| file.split("pages").last.split(".").first }
  page_files.each do |page|
    add page, priority: 0.9
  end

  post_count = BlogPost.count
  page_count = post_count / 5
  page_count += 1 unless (post_count % 5).zero?
  add pages_blog_posts_path, changefreq: "weekly", priority: 0.1
  2.upto(page_count) do |page_number|
    add pages_blog_posts_path(page: page_number), changefreq: "weekly", priority: 0.1
  end

  BlogPost.published.find_each do |post|
    add pages_blog_post_path(post.slug), lastmod: post.updated_at, priority: 0.51
  end

  BlogCategory.all.find_each do |category|
    posts = category.blog_posts
    add pages_blog_category_path(category.name),
        lastmod: posts.order(:updated_at).last.updated_at,
        priority: 0.1

    page_count = posts.count / 5
    page_count += 1 unless (posts.count % 5).zero?
    2.upto(page_count) do |page_number|
      add pages_blog_category_path(category.name, page: page_number),
          lastmod: posts.order(:updated_at).last.updated_at,
          priority: 0.1
    end
  end

  TutorAccount.published.find_each do |account|
    add pages_tutor_path(account.user.first_name)
  end

  City.published.find_each do |city|
    add public_city_path(city.slug)
  end
end
