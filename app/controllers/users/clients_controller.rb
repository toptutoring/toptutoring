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
      if @user.save
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

    def notify_through_slack_and_emails
      SLACK_NOTIFIER.ping "A new user has signed up.\n" \
        "Name: #{@user.name}\n" \
        "Email: #{@user.email}\n" \
        "Comments: #{@user.signup_attributes.comments}\n"
      UserNotifierMailer.send_signup_email(@user).deliver_now
      NewClientNotifier.perform(@user, User.admin_and_directors)
    end

    def redirect_to_root
      redirect_to root_path
    end
  end
end
