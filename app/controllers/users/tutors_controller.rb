module Users
  class TutorsController < ApplicationController
    before_action :redirect_to_root, :only => [:new, :create], :if => :signed_in?
    layout "authentication"

    def new
      @user = User.new
      @user.build_contract
    end

    def create
      @user = Clearance.configuration.user_model.new(signups_params)
      add_subjects

      if @user.save
        NewTutorNotifierMailer.welcome(@user, User.admin_and_directors).deliver_now
        sign_in(@user)
        redirect_to :root
      else
        redirect_back(fallback_location: (request.referer || root_path),
                      flash: { error: @user.errors.full_messages })
      end
    end

    #"cover page" for signing up users
    def signup
    end

    private

    def signups_params
      params.require(:user)
        .permit(:name, :email, :password)
        .merge(roles: "tutor", access_state: "enabled")
    end

    def redirect_to_root
      redirect_to root_path
    end

    def tutor_subject_params
      params.fetch(:tutor, {}).permit(subjects: [])
    end

    #Add each subject that was selected on signup to the tutor
    def add_subjects
      if !tutor_subject_params.blank?
        ((tutor_subject_params).first[1]).each do |subject_id|
          @user.subjects << Subject.find(subject_id.to_i)
        end
      end
    end

  end
end
