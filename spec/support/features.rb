require_relative 'features/session_helpers'
require_relative 'features/roles_helper'

RSpec.configure do |config|
  config.include Features::SessionHelpers, type: :feature
  config.include Features::RolesHelpers, type: :feature
end
