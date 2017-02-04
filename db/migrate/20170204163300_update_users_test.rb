class UpdateUsersTest < ActiveRecord::Migration[5.0]
  def change
    parent = User.find_by_email("parent@test.com")
    parent.update(email: "parent@example.com") if parent
    tutor = User.find_by_email("tutor@test.com")
    tutor.update(email: "tutor@example.com") if tutor
    director = User.find_by_email("director@test.com")
    director.update(email: "director@example.com") if director
    admin = User.find_by_email("admin@test.com")
    admin.update(email: "admin@example.com") if admin
  end
end
