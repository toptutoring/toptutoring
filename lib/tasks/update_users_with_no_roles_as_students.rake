namespace :update do
  task update_users_with_no_roles_as_students: :environment do
    users_to_update = User.left_joins(:roles).where(user_roles: { user_id: nil })
    student_role = Role.find_by(name: 'student')
    total = users_to_update.count
    total_updated = 0
    total_failed = 0

    users_to_update.find_each do |user|
      STDOUT.puts "Creating student role for #{user.name} with id #{user.id}"
      new_role = UserRole.new(user: user, role: student_role)
      if new_role.save
        STDOUT.puts "Success!"
        total_updated += 1
      else
        STDOUT.puts "Failure. #{new_role.errors}"
        total_failed += 1
      end
    end

    STDOUT.puts "Attempted to update #{total} users"
    unless total.zero?
      STDOUT.puts "#{total_updated} updated"
      STDOUT.puts "#{total_failed} failed"
    end
  end
end
