class UpdateTestUsers < ActiveRecord::Migration[5.0]
  def change
    User.find_by_email("parent@toptutoring.com").update(email: "parent@test.com")
    User.find_by_email("tutor@toptutoring.com").update(email: "tutor@test.com")
    User.find_by_email("director@toptutoring.com").update(email: "director@test.com")
    User.find_by_email("admin@toptutoring.com").update(email: "admin@test.com")
  end
end
