module Admin
  class SubjectsController < ApplicationController
    def index
      @subjects = Subject.all.order(:name)
    end

    def update
      @subject = Subject.find(params[:id])
      if update_status
        flash.notice = "Tutoring Type has been changed to #{@type} for #{@subject.name}."
      else
        flash[:error] = "Could not update tutoring type for #{@subject.name}."
      end
      redirect_to action: "index"
    end

    private

    def update_status
      @type = params[:subject][:academic_type]
      if @type == "Academic"
        @subject.academic!
      elsif @type == "Test Prep"
        @subject.test_prep!
      end
    end
  end
end
