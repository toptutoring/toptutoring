CarrierWave.configure do |config|
  storage_type = Rails.env.test? ? :file : :fog

  config.fog_provider = "fog/aws"
  config.fog_credentials = {
    provider:              "AWS",
    aws_access_key_id:     ENV.fetch("AWS_ACCESS_KEY"),
    aws_secret_access_key: ENV.fetch("AWS_SECRET_KEY"),
    region:                ENV.fetch("AWS_REGION")
  }
  config.fog_directory = ENV.fetch("AWS_S3_BUCKET_NAME")

  # Add additional options
  # config.fog_attributes = { cache_control: "publi, max-age=#{365.days.to_i}" }  defaults to {}

  config.storage = storage_type
  # test configurations
  config.enable_processing = false if Rails.env.test?
end
