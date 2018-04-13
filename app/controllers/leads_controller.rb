class LeadsController < ApplicationController
  def index
    @leads = Lead.active
                 .order(created_at: :desc)
  end

  def create
    @lead = Lead.new(lead_params)
    SlackNotifier.notify_new_lead(@lead) if @lead.save
  end

  def update
    @lead = Lead.find(params[:id])
    if @lead.update(archived: true)
      @archived = true
      @count = Lead.active.count
      flash.now.notice = "Archived lead."
    else
      flash.now.alert = "Unable to archive lead."
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
end
