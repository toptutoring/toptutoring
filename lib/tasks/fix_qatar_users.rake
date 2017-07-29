namespace :update do
  task :fix_qatar_users => :environment do

    nadjiba = User.find(72)
    nadjiba.name = "Nadjiba"
    nadjiba.save!

    tayba = User.find(70)
    tayba.name = "Tayba"
    tayba.client_id = nadjiba.id
    tayba.save!

    if !tayba.client_engagements.empty?
      nadjiba_tayba_engagement = tayba.client_engagements.last
      nadjiba_tayba_engagement.client_id = nadjiba.id
      nadjiba_tayba_engagement.student_name = tayba.name
      nadjiba_tayba_engagement.save!
    end

    melek = User.find(71)
    melek.client_id = nadjiba.id
    melek.save!

    melek_client_info = melek.client_info
    melek_client_info.student = true
    melek_client_info.save!

    if melek.student_engagements.empty?
      nadjiba_melek_client_engagement = Engagement.new
      nadjiba_melek_client_engagement.student_id = melek.id
      nadjiba_melek_client_engagement.student_name = melek.name
      nadjiba_melek_client_engagement.subject = melek.client_info.subject
      nadjiba_melek_client_engagement.client_id = nadjiba.id
      nadjiba_melek_client_engagement.academic_type = "Academic"
      nadjiba_melek_client_engagement.save!
    end

  end
end
