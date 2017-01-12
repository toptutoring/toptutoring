class AssignmentsController < ApplicationController
  before_action :require_login
  before_action :set_tutors, only: :edit
  before_action :set_assignment, only: [:edit, :update]

  def index
    @assignments = Assignment.order('created_at DESC')
  end

  def update
    if @assignment.update_attributes(assignment_params)
      @assignment.enable!
      redirect_to assignments_path, notice: 'Assignment successfully made!'
    else
      redirect_to :back, flash: { error: @assignment.errors.full_messages }
    end
  end

  private

  def assignment_params
    params.require(:assignment).permit(:tutor_id, :student_id, :subject, :academic_type, :hourly_rate)
  end

  def set_assignment
    @assignment = Assignment.find(params[:id])
  end

  def set_tutors
    @tutors = User.all.select { |user| user.tutor? }
  end
end
