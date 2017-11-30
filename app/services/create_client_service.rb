class CreateClientService
  class << self
    Result = Struct.new(:success?, :user, :messages)

    def create!(params)
      ActiveRecord::Base.transaction do
        @user = Clearance.configuration.user_model.new(params)
        @user.save!
        create_client_account!
        create_student_account!
      end
      notify_through_slack_and_emails
      Result.new(true, @user, nil)
    rescue ActiveRecord::RecordInvalid => e
      Result.new(false, nil, e)
    end

    private

    def create_client_account!
      @user.create_client_account!
    end

    def create_student_account!
      return unless @user.is_student?
      @user.client_account.student_accounts.create!(user: @user, name: @user.name)
    end

    def notify_through_slack_and_emails
      SlackNotifier.notify_user_signup_start(@user)
      UserNotifierMailer.send_signup_email(@user).deliver_later
      NewClientNotifierMailer.started_sign_up(@user).deliver_later
    end
  end
end
