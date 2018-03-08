require "carrierwave"

class ProfilePictureUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  process resize_to_fit: [400, 600]

  version :tile do
    process resize_to_fill: [360, 360]
  end

  version :thumbnail do
    process resize_to_fill: [75, 75]
  end
end
