class EmailsController < ApplicationController
  before_action :require_login
  before_action :set_student, :set_client, :authorize_tutor, only: [:new, :create]
  before_action :check_client, only: [:create]

  def new
    @email = Email.new
    @invoice = @student.assignment.invoices.last
  end

  def create
    @email = Email.create(email_params)
    if @email.save
      TutorMailer.perform(@email.id).deliver_now
      redirect_to tutors_students_path, notice: 'Email has been sent!'
    else
      redirect_back(fallback_location: (request.referer || root_path),
                    flash: { error: @email.errors.full_messages })
    end
  end

  private

  def email_params
    params.require(:email).permit(:client_id, :subject, :body)
    .merge(tutor_id: current_user.id)
  end

  def set_student
    @student = User.find(params[:id])
  end

  def set_client
    @client = @student.is_student? ? @student : @student.client
  end

  def check_client
    if @client.id != email_params[:client_id].to_i
      redirect_back(fallback_location: (request.referer || root_path),
                    flash: { error: 'Invalid receiver!' })
    end
  end

  def authorize_tutor
    if @student.assignment.nil? || @student.assignment.tutor_id != current_user.id
      render file: "#{Rails.root}/public/404.html", layout: false, status: 404
    end
  end
end
