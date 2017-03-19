class CreateUserRoles < ActiveRecord::Migration[5.0]
  def change
    create_table :user_roles do |t|
      t.references :user, index: true
      t.references :role, index: true
    end
  end
end
