require 'clockwork'
require './config/boot'
require './config/environment'
require 'rake'

module Clockwork
  every(2.weeks, 'update_tokens') do
    UpdateTokensWorker.perform_async
  end
end
