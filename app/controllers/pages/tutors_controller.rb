module Pages
  class TutorsController < ApplicationController
    layout "authentication"
    def index
      @tutor_accounts = TutorAccount.published.limit(9).includes(:user)
    end

    def show
      @tutor = User.joins(:tutor_account)
                   .where(tutor_accounts: { publish: true })
                   .find_by(first_name: name_param)
      not_found unless @tutor
    end

    private

    def name_param
      params.require(:first_name)
    end
  end
end
