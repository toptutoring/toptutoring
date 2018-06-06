require "rails_helper"

feature "Blog Categories Index" do
  let(:admin) { User.admin }
  let!(:blog_category) { FactoryBot.create(:blog_category) }

  before :each do
    sign_in(admin)
    visit blog_categories_path
  end

  scenario "visitng the index page" do
    expect(page).to have_link("Back to Blog Posts")
    expect(page).to have_button("Create Blog Category")
    expect(page).to have_selector("input[value='#{blog_category.name}']")
    expect(page).to have_content(blog_category.blog_posts.count)
    expect(page).to have_link(href: blog_category_path(blog_category))
  end

  scenario "creating a new category" do
    original_count = BlogCategory.count
    new_cat = "New Category"
    find("#category_name").set(new_cat)
    click_on "Create Blog Category"

    expect(page).to have_content("#{new_cat} has been added.")
    expect(page).to have_selector("input[value='#{new_cat}']")
    expect(BlogCategory.count).to eq original_count + 1
  end

  scenario "removing a category", js: true do
    original_count = BlogCategory.count
    page.accept_confirm do
      find_link(href: blog_category_path(blog_category)).click
    end

    expect(page).to have_content("#{blog_category.name} has been removed.")
    expect(page).not_to have_selector("input[value='#{blog_category.name}']")
    expect(BlogCategory.count).to eq original_count - 1
  end
end
