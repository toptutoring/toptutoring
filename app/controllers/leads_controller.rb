class LeadsController < ApplicationController
  def index
    @leads = Lead.all
                 .order(created_at: :desc)
                 .paginate(page: params[:page], per_page: 10)
  end

  def create
    @lead = Lead.new(lead_params)
    SlackNotifier.notify_new_lead(@lead) 
    flash.now.alert = t("www.contact.failure") unless @lead.save
  end

  def update
    @lead = Lead.find(params[:id])
    if @lead.update(archived: true)
      flash.notice = "Lead has been archived"
    else
      flash.alert = "Unable to archive lead. #{errrors}"
    end
    redirect_to action: :index
  end

  def destroy
    @lead = Lead.find(params[:id])
    if @lead.destroy
      flash.now.notice = "Lead has been deleted."
    else
      flash.now.alert = "Unable to delete lead. #{errors}"
    end
  end

  private

  def lead_params
    params.require(:lead)
          .permit(:first_name, :last_name, :zip,
                  :phone_number, :email,
                  :subject_id, :comments)
          .merge(country_code: country_code)
  end

  def errors
    @lead.errors.full_messages.join(", ")
  end
end
