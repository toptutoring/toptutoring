class CreateClientService
  class << self
    Result = Struct.new(:success?, :user, :messages)

    def create!(params, password, code)
      @user = User.new(params)
      return password_failure unless passwords_match?(params, password)
      ActiveRecord::Base.transaction do
        @user.country_code = code
        @user.save!
        @user.enable!
        create_accounts!
      end
      notify_through_slack_and_emails
      Result.new(true, @user, I18n.t(success_message))
    rescue ActiveRecord::RecordInvalid => e
      Result.new(false, @user, @user.errors.full_messages)
    end

    private

    def student?
      @user.signup.student
    end

    def create_accounts!
      @user.create_client_account!
      return unless student?
      @user.client_account.student_accounts.create!(user: @user, name: @user.full_name)
    end

    def notify_through_slack_and_emails
      SlackNotifier.notify_user_signup_start(@user)
      UserNotifierMailer.send_signup_email(@user).deliver_later
      AdminDirectorNotifierMailer.new_user_registered(@user).deliver_later
    end

    def success_message
      return "app.signup.client.success_message" unless student?
      "app.signup.client_student.success_message"
    end

    def passwords_match?(params, password)
      params[:password] == password
    end

    def password_failure
      Result.new(false, @user, I18n.t("app.signup.password_fail"))
    end
  end
end
