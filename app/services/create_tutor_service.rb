class CreateTutorService
  class << self
    Result = Struct.new(:success?, :user, :message)

    def create!(user_params, subject_params)
      ActiveRecord::Base.transaction do
        @user = Clearance.configuration.user_model.new(user_params)
        @user.save!
        @user.create_tutor_account!
        @user.tutor_account.create_contract!(hourly_rate: 15)
        add_subjects(subject_params)
      end
      NewTutorNotifierMailer.mail_admin_and_directors(@user).deliver_later
      Result.new(true, @user, I18n.t("app.signup.tutors.success"))
    rescue ActiveRecord::RecordInvalid => e
      Result.new(false, @user, e)
    end

    private

    #Add each subject that was selected on signup to the tutor
    def add_subjects(subject_params)
      unless subject_params.blank?
        subject_params[:subjects].each do |subject_id|
          @user.subjects << Subject.find(subject_id)
        end
      end
    end
  end
end
