module Admin
  class SubjectsController < ApplicationController
    skip_before_action :verify_authenticity_token, only: :update

    def index
      @subjects = Subject.all.order(:name).includes(tutor_profiles: :user)
    end

    def update
      @subject = Subject.find(params[:id])
      respond_to do |format|
        if update_status
          format.json do
            render json: { message: "#{@subject.name} has been" \
                           "changed to #{@subject.tutoring_type}" }
          end
        else
          format.json { render json: { message: "Failed to update" } }
        end
      end
    end

    private

    def update_status
      @type = params[:subject][:tutoring_type]
      if @type == 'academic'
        @subject.academic!
      elsif @type == 'test_prep'
        @subject.test_prep!
      end
    end
  end
end
