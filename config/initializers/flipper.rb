Flipper.configure do |config|
  config.default do
    Flipper.new Flipper::Adapters::ActiveRecord.new
  end
end

Flipper::UI.configure do |config|
  config.banner_text = "Production Environment"
  config.banner_class = "danger"
end
