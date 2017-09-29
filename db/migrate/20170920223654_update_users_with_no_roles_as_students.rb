class UpdateUsersWithNoRolesAsStudents < ActiveRecord::Migration[5.1]
  Rake::Task['update:update_users_with_no_roles_as_students'].invoke
end
