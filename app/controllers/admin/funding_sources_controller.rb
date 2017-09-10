module Admin
  class FundingSourcesController < ApplicationController
    before_action :require_login, :set_funding_source
    before_action :check_funding_source, only: :new
    before_action :get_funding_sources, only: [:new, :edit]

    def new
      @funding_source = FundingSource.new
    end

    def create
      funding_source = FundingSource.new(funding_source_params)
      if funding_source.save
        redirect_back(fallback_location: (request.referer || root_path),
                      notice: "Funding source successfully set.")
      else
        redirect_back(fallback_location: (request.referer || root_path),
                      flash: { error: funding_source.errors.full_messages })
      end
    end

    def update
      if @funding_source.update(funding_source_params)
        redirect_back(fallback_location: (request.referer || root_path),
                      notice: "Funding source successfully set.")
      else
        redirect_back(fallback_location: (request.referer || root_path),
                      flash: { error: @funding_source.errors.full_messages })
      end
    end

    private

    def funding_source_params
      params.require(:funding_source).permit(:funding_source_id).merge(user_id: current_user.id)
    end

    def set_funding_source
      @funding_source  = FundingSource.last
    end

    def get_funding_sources
      @funding_sources = DwollaService.funding_sources
    rescue DwollaV2::Error => e
      @funding_sources = []
      message = "DwollaV2 Error: #{e}"
      Bugsnag.notify(e)
      Rails.logger.error(message)
      flash[:danger] = message
    end

    def check_funding_source
      if @funding_source
        redirect_to edit_admin_funding_source_path(@funding_source)
      end
    end
  end
end
