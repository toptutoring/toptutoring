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
      subject = Subject.find_by_name(user.signup.subject)
      user.signup.subject = subject.id
      user.signup.save!
    end
  end
end
