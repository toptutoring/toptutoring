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
        redirect_to :back, notice: 'Funding source successfully set.'
      else
        flash[:danger] = funding_source.errors.full_messages
        redirect_to :back
      end
    end

    def update
      if @funding_source.update(funding_source_params)
        redirect_to :back, notice: 'Funding source successfully set.'
      else
        flash[:danger] = @funding_source.errors.full_messages
        redirect_to :back
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
      @funding_sources = DwollaService.new.funding_sources
    end

    def check_funding_source
      if @funding_source
        redirect_to edit_admin_funding_source_path(@funding_source)
      end
    end
  end
end
