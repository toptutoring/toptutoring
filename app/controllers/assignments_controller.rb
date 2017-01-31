class AssignmentsController < ApplicationController
  before_action :require_login
  before_action :set_tutors, only: :edit
  before_action :set_assignment, only: [:edit, :update, :enable, :disable]

  def index
    @assignments = Assignment.order('created_at DESC')
  end

  def update
    if @assignment.update_attributes(assignment_params)
      redirect_to assignments_path, notice: 'Assignment successfully updated!'
    else
      redirect_to :back, flash: { error: @assignment.errors.full_messages }
    end
  end

  def enable
    if @assignment.enable!
      redirect_to :back, notice: 'Assignment successfully enabled!'
    else
      redirect_to :back, flash: { error: @assignment.errors.full_messages }
    end
  end

  def disable
    if @assignment.disable!
      redirect_to :back, notice: 'Assignment successfully disabled!'
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
    @tutors = User.with_tutor_role
  end
end
