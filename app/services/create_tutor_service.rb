class CreateTutorService
  class << self
    Result = Struct.new(:success?, :user, :message)

    def create!(user_params, password, subject_params)
      @tutor = User.new(user_params)
      return password_failure unless passwords_match?(user_params, password)
      ActiveRecord::Base.transaction do
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

    def passwords_match?(params, password)
      params[:password] == password
    end

    def password_failure
      Result.new(false, @tutor, I18n.t("app.signup.password_fail"))
    end
  end
end
