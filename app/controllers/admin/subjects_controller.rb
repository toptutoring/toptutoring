module Admin
  class SubjectsController < ApplicationController
    before_action :set_subject, only: [:update, :switch_category, :update_name, :destroy]
    def index
      @subjects = Subject.all.order(:name)
      @category_options = Subject.categories.values.map { |cat| [cat.titlecase, cat] }
    end

    def create
      @subject = Subject.new(subject_params)
      if @subject.save
        flash.notice = "#{@subject.name} has been created."
      else
        flash.alert = @subject.errors.full_messages
      end
      redirect_to action: :index
    end

    def update
      if update_status
        flash.notice = "Tutoring Type has been changed to #{@type} for #{@subject.name}."
      else
        flash.alert = "Could not update tutoring type for #{@subject.name}."
      end
      redirect_to action: "index"
    end

    def switch_category
      @updated = @subject.update(category_params)
      flash.now[:alert] = @subject.errors.full_messages unless @updated
    end

    def update_name
      @updated = @subject.update(name_params)
      flash.now[:alert] = @subject.errors.full_messages unless @updated
    end

    def destroy
      @subject.destroy
      flash.now.notice = "#{@subject.name} has been removed."
    rescue ActiveRecord::InvalidForeignKey => e
      flash.now.alert = "#{@subject.name} is currently associated with an engagement. It cannot be removed."
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

    def category_params
      params.require(:subject).permit(:category)
    end

    def name_params
      params.require(:subject).permit(:name)
    end

    def subject_params
      params.require(:subject).permit(:name, :category, :academic_type)
    end

    def set_subject
      @subject = Subject.find(params[:id])
    end
  end
end
