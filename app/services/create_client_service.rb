class CreateClientService
  class << self
    Result = Struct.new(:success?, :user, :messages)

    def create!(params, code)
      ActiveRecord::Base.transaction do
        @user = Clearance.configuration.user_model.new(params)
        @user.country_code = code
        @user.save!
        @user.enable!
        create_accounts!
      end
      notify_through_slack_and_emails
      Result.new(true, @user, I18n.t(message))
    rescue ActiveRecord::RecordInvalid => e
      Result.new(false, @user, e)
    end

    private

    def student?
      @user.signup.student
    end

    def create_accounts!
      @user.create_client_account!
      return unless student?
      @user.client_account.student_accounts.create!(user: @user, name: @user.name)
    end

    def notify_through_slack_and_emails
      SlackNotifier.notify_user_signup_start(@user)
      UserNotifierMailer.send_signup_email(@user).deliver_later
      AdminDirectorNotifierMailer.new_user_registered(@user).deliver_later
    end

    def message
      return "app.signup.client.success_message" unless student?
      "app.signup.client_student.success_message"
    end
  end
end
