class LeadsController < ApplicationController
  def create
    @lead = Lead.new(lead_params)
    @lead.save
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
