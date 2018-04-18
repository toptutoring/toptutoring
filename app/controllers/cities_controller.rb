class CitiesController < ApplicationController
  def show
    @city = City.find_by!(slug: slug)
    @phone_number = Phonelib.parse(@city.phone_number, @city.country.code)
    render layout: "authentication"
  end

  def slug
    params.require(:slug)
  end
end
