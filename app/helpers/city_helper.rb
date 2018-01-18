module CityHelper
  def publish_or_remove_link(city)
    link = city.published? ? "Remove" : "Publish"
    link_to link, publish_admin_city_path(city), method: :post, class: "btn btn-success"
  end
end
