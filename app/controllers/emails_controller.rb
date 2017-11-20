class EmailsController < ApplicationController
  before_action :require_login
  before_action :set_student, :set_client, :authorize_tutor, only: [:new, :create]
  before_action :check_client, only: [:create]
  before_action :set_invoice, only: [:new]

  def new
    @email = Email.new
  end

  def create
    @email = Email.create(email_params)
    if @email.save
      TutorMailer.send_mail(@email).deliver_later
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

  def set_invoice
    @invoice = current_user.invoices.where(client_id: @client.id).last
  end

  def set_client
    @client = @student.client
  end

  def check_client
    if @client.id != email_params[:client_id].to_i
      redirect_back(fallback_location: (request.referer || root_path),
                    flash: { error: 'Invalid receiver!' })
    end
  end

  def authorize_tutor
    if @student.student_engagements.blank? || @student.student_engagements.pluck(:tutor_id).exclude?(current_user.id)
      render file: "#{Rails.root}/public/404.html", layout: false, status: 404
    end
  end
end
