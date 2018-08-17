Rails.application.configure do
  # Verifies that versions and hashed value of the package contents in the project's package.json
config.webpacker.check_yarn_integrity = true

  config.cache_classes = false
  config.eager_load = false
  config.consider_all_requests_local = true
  if Rails.root.join('tmp/caching-dev.txt').exist?
    config.action_controller.perform_caching = true
    config.cache_store = :memory_store
    config.public_file_server.headers = {
      'Cache-Control' => 'public, max-age=172800'
    }
  else
    config.action_controller.perform_caching = false
    config.cache_store = :null_store
  end
  config.action_mailer.raise_delivery_errors = true
  config.after_initialize do
    Bullet.enable = true
    Bullet.bullet_logger = true
    Bullet.rails_logger = true
  end
  # During development, emails are saved as files in tmp/mails
  config.action_mailer.delivery_method = :letter_opener
  config.active_support.deprecation = :log
  config.active_record.migration_error = :page_load
  config.action_controller.asset_host = "http://#{ENV.fetch("APPLICATION_HOST")}"
  config.action_mailer.asset_host = config.action_controller.asset_host
  config.action_mailer.default_url_options = { host: ENV.fetch("APPLICATION_HOST") }
  config.assets.debug = true
  config.assets.quiet = true
  config.action_view.raise_on_missing_translations = true
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker
end
