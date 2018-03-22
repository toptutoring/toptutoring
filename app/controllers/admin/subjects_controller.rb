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
        flash.alert = "Could not update tutoring type for #{@subject.name}."
      end
      redirect_to action: "index"
    end

    def switch_category
      @subject = Subject.find(params[:id])
      @updated = @subject.update(subject_params)
      flash.now[:alert] = @subject.errors.full_messages unless @updated
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

    def subject_params
      params.require(:subject).permit(:category)
    end
  end
end
