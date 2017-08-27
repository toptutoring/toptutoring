class RoomsController < ApplicationController
  before_action :set_tutor, :set_student

  def create
    opentok = OpentokApi.new
    session = opentok.create_session

    tutor_token = opentok.get_user_token(@tutor, session.session_id)
    student_token = opentok.get_user_token(@student, session.session_id)

    room = Room.create(room_params.merge({
      tutor_token: tutor_token,
      student_token: student_token,
      session_id: session.session_id,
      name: @tutor.name
    }))
  end

  private

  def room_params
    params.require(:room).permit(:tutor_id, :student_id)
  end

  def set_tutor
    @tutor = User.find(room_params[:tutor_id])
  end

  def set_student
    @student = User.find(room_params[:student_id])
  end
end
