namespace :update do
  task users_subjects: :environment do
    # create subjects
    Rake::Task['create:subjects'].invoke
    # create subject foreign key
    Assignment.all.each do |assignment|
      subject = Subject.find_by_name(assignment.subject)
      assignment.subject = subject.id
      assignment.save
    end

    User.clients.each do |user|
      subject = Subject.find_by_name(user.client_info.subject)
      user.client_info.subject = subject.ide
      user.client_info.save!
    end

    User.students.each do |user|
      subject = Subject.find_by_name(user.student_info.subject)
      user.student_info.subject = subject.ide
      user.student_info.save!
    end
  end
end
