class AvailabilityController < ApplicationController

  def new
    @days = %w(Monday Tuesday Wednesday Thursday Friday Saturday Sunday)
  end

  def create
  end
end
