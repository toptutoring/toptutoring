class EngagementsController < ApplicationController
  before_action :require_login
  before_action :set_tutors, only: :edit
  before_action :set_engagement, only: [:edit, :update, :enable, :disable]

  def index
    @engagements = Engagement.order('created_at DESC')
                             .includes(:subject, :student_account, client_account: :user, tutor_account: :user)
  end

  def edit
    @student_accounts = @engagement.client.student_accounts
  end

  def update
    if @engagement.update_attributes(engagement_params)
      redirect_to engagements_path, notice: 'Engagement successfully updated!'
    else
      redirect_back(fallback_location: (request.referer || root_path),
                    flash: { error: @engagement.errors.full_messages })
    end
  end

  def enable
    if @engagement.enable!
      redirect_back(fallback_location: (request.referer || root_path),
                     notice: 'Engagement successfully enabled!')
    else
      redirect_back(fallback_location: (request.referer || root_path),
                    flash: { error: @engagement.errors.full_messages })
    end
  end

  def disable
    if @engagement.disable!
      redirect_back(fallback_location: (request.referer || root_path),
                     notice: 'Engagement successfully disabled!')
    else
      redirect_back(fallback_location: (request.referer || root_path),
                    flash: { error: @engagement.errors.full_messages })
    end
  end

  private

  def engagement_params
    params.require(:engagement)
          .permit(:tutor_account_id, :student_account_id, :subject_id)
  end

  def set_engagement
    @engagement = Engagement.find(params[:id])
  end

  def set_tutors
    @tutor_accounts = TutorAccount.where(user_id: User.tutors.ids)
                                  .includes(:user)
  end
end
