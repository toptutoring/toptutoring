class TutorsController < ApplicationController
  def new
    binding.pry
    @tutor = User.new.build_tutor
  end
end
