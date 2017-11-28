module Users
  class ClientsController < ApplicationController
    before_action :redirect_to_root, :only => [:new, :create], :if => :signed_in?
    layout "authentication"

    def new
      @user = User.new
      @user.build_signup
    end

    def create
      @user = Clearance.configuration.user_model.new(signups_params)
      if @user.save && create_client_account && create_student_account
        notify_through_slack_and_emails
        sign_in(@user)
        redirect_to :root
      else
        redirect_back(fallback_location: (request.referer || root_path),
                      flash: { error: @user.errors.full_messages })
      end
    end

    private

    def signups_params
      params.require(:user)
            .permit(:name, :email, :password,
                    signup_attributes: [:student, :subject, :comments])
            .merge(roles: Role.where(name: "client"))
    end

    def create_client_account
      @user.create_client_account
    end

    def create_student_account
      return true unless @user.is_student?
      @user.create_student_account(client_account: @user.client_account, name: @user.name)
      @user.student_account.persisted?
    end

    def notify_through_slack_and_emails
      SlackNotifier.notify_user_signup_start(@user)
      UserNotifierMailer.send_signup_email(@user).deliver_later
      NewClientNotifierMailer.started_sign_up(@user).deliver_later
    end

    def redirect_to_root
      redirect_to root_path
    end
  end
end
