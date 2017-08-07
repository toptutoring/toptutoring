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
      nadjiba_melek_engagement = Engagement.new
      nadjiba_melek_engagement.student_id = melek.id
      nadjiba_melek_engagement.student_name = melek.name
      nadjiba_melek_engagement.subject = melek.client_info.subject
      nadjiba_melek_engagement.client_id = nadjiba.id
      nadjiba_melek_engagement.academic_type = "Academic"
      nadjiba_melek_engagement.save!
    end

    iskandar = User.find(73)
    iskandar.name = "Iskandar"
    iskandar.client_id = nadjiba.id
    iskandar.save!

    if !iskandar.client_engagements.empty?
      nadjiba_iskandar_engagement = iskandar.client_engagements.last
      nadjiba_iskandar_engagement.client_id = nadjiba.id
      nadjiba_iskandar_engagement.subject = "10th-grade Science"
      nadjiba_iskandar_engagement.student_name = iskandar.name
      nadjiba_iskandar_engagement.save!
    end

    iskandar_client_info = iskandar.client_info
    iskandar_client_info.subject = "10th-grade Science"
    iskandar_client_info.save!
  end
end
