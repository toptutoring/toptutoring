class CitiesController < ApplicationController
  layout "authentication"

  def show
    @city = City.find_by!(slug: params.require(:slug))
  end
end
