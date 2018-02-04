class CreateTutorService
  class << self
    Result = Struct.new(:success?, :user, :message)

    def create!(user_params, subject_params)
      ActiveRecord::Base.transaction do
        @tutor = Clearance.configuration.user_model.new(user_params)
        @tutor.save!
        @tutor.create_tutor_account!
        add_subjects(subject_params)
      end
      NewTutorNotifierMailer.mail_admin_and_directors(@tutor).deliver_later
      Result.new(true, @tutor, I18n.t("app.signup.tutors.success"))
    rescue ActiveRecord::RecordInvalid => e
      Result.new(false, @tutor, e)
    end

    private

    #Add each subject that was selected on signup to the tutor
    def add_subjects(subject_params)
      @tutor.tutor_account.subject_ids = subject_params[:subjects]
    end
  end
end
