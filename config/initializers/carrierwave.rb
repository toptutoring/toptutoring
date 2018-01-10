CarrierWave.configure do |config|
  config.storage = :file

  if Rails.env.test?
    config.storage = :file
    config.enable_processing = false
  end

  if Rails.env.development?
    config.ignore_integrity_errors = false
    config.ignore_processing_errors = false
    config.ignore_download_errors = false
  end
end
