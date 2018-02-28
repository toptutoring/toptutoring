class EngagementsController < ApplicationController
  before_action :require_login
  before_action :set_tutors, only: [:new, :edit]
  before_action :set_engagement, only: [:edit, :update, :enable, :disable]

  def index
    @engagements = Engagement.order("created_at DESC")
                             .includes(:subject, :student_account, client_account: :user, tutor_account: :user)
  end

  def new
    @students = ClientAccount.all.map do |account|
      next unless account.student_accounts.any?
      [account.user.full_name, student_options(account)]
    end
    @students.compact!
  end

  def create
    engagement = Engagement.new(new_engagement_params)
    if engagement.save
      flash.notice = "Engagement successfully created!"
      redirect_to action: :index
    else
      flash.alert = engagement.errors.full_messages
      redirect_to action: :new
    end
  end

  def update
    if @engagement.update_attributes(engagement_params)
      redirect_to engagements_path, notice: "Engagement successfully updated!"
    else
      redirect_back(fallback_location: (request.referer || root_path),
                    flash: { error: @engagement.errors.full_messages })
    end
  end

  def enable
    if @engagement.enable!
      redirect_back(fallback_location: (request.referer || root_path),
                     notice: "Engagement successfully enabled!")
    else
      redirect_back(fallback_location: (request.referer || root_path),
                    flash: { error: @engagement.errors.full_messages })
    end
  end

  def disable
    if @engagement.disable!
      redirect_back(fallback_location: (request.referer || root_path),
                     notice: "Engagement successfully disabled!")
    else
      redirect_back(fallback_location: (request.referer || root_path),
                    flash: { error: @engagement.errors.full_messages })
    end
  end

  private

  def engagement_params
    params.require(:engagement)
          .permit(:tutor_account_id, :subject_id)
  end

  def new_engagement_params
    new_params = params.require(:engagement)
                       .permit(:tutor_account_id, :student_account_id, :subject_id)
    account = StudentAccount.find_by_id(params[:engagement][:student_account_id])
    new_params.merge(client_account: account.client_account) if account
  end

  def set_engagement
    @engagement = Engagement.find(params[:id])
  end

  def set_tutors
    @tutor_accounts = TutorAccount.where(user_id: User.tutors.ids)
                                  .includes(:user)
  end

  def student_options(account)
    account.student_accounts.map do |student_account|
      [student_account.name, student_account.id]
    end
  end
end
