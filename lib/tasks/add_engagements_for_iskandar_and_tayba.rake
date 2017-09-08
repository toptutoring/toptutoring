namespace :update do
  task :add_engagements_for_iskandar_and_tayba => :environment do
    def already_performed?
      Engagement.where(client_id: @nadjiba.id, student_id: @tayba.id, subject: @middle_school_science.name).any? &&
        Engagement.where(client_id: @nadjiba.id, student_id: @iskandar.id, subject: @high_school_math.name).any?
    end

    @nadjiba = User.find(72)
    @tayba = User.find(70)
    @iskandar = User.find(73)
    @middle_school_science = Subject.find(190)
    @high_school_math = Subject.where(name: 'High School Math').first_or_create(name: 'High School Math')

    if already_performed?
      puts 'This update has already been performed.'
    else
      Engagement.transaction do
        Engagement.create!(student_id: @tayba.id,
                           student_name: @tayba.name,
                           client_id: @nadjiba.id,
                           state: 'pending',
                           subject: @middle_school_science.name,
                           academic_type: 'Academic')

        Engagement.create!(student_id: @iskandar.id,
                           student_name: @iskandar.name,
                           client_id: @nadjiba.id,
                           state: 'pending',
                           subject: @high_school_math.name,
                           academic_type: 'Academic')
      end

      puts 'Engagements for Iskandar and Tayba created.'
    end
  end
end
