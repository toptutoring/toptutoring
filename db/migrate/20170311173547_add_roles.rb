class AddRoles < ActiveRecord::Migration[5.0]
  def change
    Role.create(name: "admin")
    Role.create(name: "director")
    Role.create(name: "tutor")
    Role.create(name: "client")
    Role.create(name: "student")
  end
end
