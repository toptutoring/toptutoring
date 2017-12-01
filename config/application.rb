require_relative 'boot'
require "rails"
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
require "sprockets/railtie"
Bundler.require(*Rails.groups)
module TopTutoring
  class Application < Rails::Application
    config.assets.quiet = true
    config.generators do |generate|
      generate.helper false
      generate.javascript_engine false
      generate.request_specs false
      generate.routing_specs false
      generate.stylesheets false
      generate.test_framework :rspec
      generate.view_specs false
    end

    config.paths["config/routes.rb"] =
      (Dir["config/routes/*.rb"] << "config/routes.rb").map { |relative_path| Rails.root.join(relative_path)}

    config.autoload_paths += %W(#{config.root}/lib/cli)
    config.autoload_paths += %W(#{config.root}/app/services)
    config.autoload_paths += %W(#{config.root}/router/**)
    config.autoload_paths += %W(#{config.root}/router.rb)
    config.action_mailer.preview_path = "#{Rails.root}/lib/mailer_previews"
    config.action_controller.action_on_unpermitted_parameters = :raise
    config.active_job.queue_adapter = :sidekiq
  end
end
