class CreateTutorService
  class << self
    Result = Struct.new(:success?, :user, :message)

    def create!(agreement_accepted, user_params, password)
      @tutor = User.new(user_params)
      return failure if invalid?(agreement_accepted, user_params, password)
      if @tutor.save
        AdminDirectorNotifierMailer.new_tutor(@tutor).deliver_later
        Result.new(true, @tutor, I18n.t("app.signup.tutors.success"))
      else
        Result.new(false, @tutor, @tutor.errors.full_messages)
      end
    end

    private

    def invalid?(agreement_accepted, params, password)
      if !agreement_accepted
        @error = I18n.t("app.signup.tutors.agreement_fail")
      elsif passwords_invalid?(params, password)
        @error = I18n.t("app.signup.password_fail")
      else
        false
      end
    end

    def passwords_invalid?(params, password)
      params[:password] != password
    end

    def failure
      Result.new(false, @tutor, @error)
    end
  end
end
