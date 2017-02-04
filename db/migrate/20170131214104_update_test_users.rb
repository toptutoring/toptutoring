class UpdateTestUsers < ActiveRecord::Migration[5.0]
  def change
    parent = User.find_by_email("parent@toptutoring.com")
    parent.update(email: "parent@test.com") if parent
    tutor = User.find_by_email("tutor@toptutoring.com")
    tutor.update(email: "tutor@test.com") if tutor
    director = User.find_by_email("director@toptutoring.com")
    director.update(email: "director@test.com") if director
    admin = User.find_by_email("admin@toptutoring.com")
    admin.update(email: "admin@test.com") if admin
  end
end
