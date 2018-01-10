require "rails_helper"

feature "Blog post crud specs", js: true do
  let(:admin) { FactoryBot.create(:admin_user) }
  let(:post) { FactoryBot.create(:blog_post) }
  
  scenario "creating a post with valid params" do
    sign_in(admin)
    visit new_blog_post_path
    blog_title = "A Title"
    blog_content = "Content for blog"
    find("#blog-title-contenteditable").base.send_keys(blog_title)
    find("#blog-content-contenteditable").base.send_keys(blog_content)
    find("input[type='submit']", visible: false).click

    expect(page).to have_content "Post successfully created"
    expect(page).to have_content blog_title
    expect(page).to have_content l(Date.current)
    expect(page).to have_content blog_content
    expect(page).to have_link "Edit Post"
    expect(page).to have_link"All Posts"
    expect(BlogPost.count).to be 1
  end

  scenario "editing a post with valid params" do
    sign_in(admin)
    visit edit_blog_post_path(post)
    blog_title = "A Title"
    blog_content = "Content for blog"
    find("#blog-title-contenteditable").base.send_keys(blog_title)
    find("#blog-content-contenteditable").base.send_keys(blog_content)
    find("input[type='submit']", visible: false).click

    expect(page).to have_content blog_title
    expect(page).to have_content blog_content
    expect(BlogPost.count).to be 1
  end

  scenario "visiting the index and show page" do
    post
    sign_in(admin)
    visit blog_posts_path

    expect(page).to have_content post.title
    expect(page).to have_content l(post.publish_date)
    
    click_on post.title

    expect(page).to have_content post.title
    expect(page).to have_content l(post.publish_date)
    expect(page).to have_content ActionView::Base.full_sanitizer.sanitize(post.content)
    expect(page).to have_link "Edit Post"
    expect(page).to have_link"All Posts"
  end
end
