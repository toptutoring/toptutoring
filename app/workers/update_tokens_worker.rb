class UpdateTokensWorker
  include Sidekiq::Worker
  sidekiq_options retry: 2

  def perform
    User.with_external_auth.each do |user|
      DwollaService.refresh_token!(user)
    end
  end
end
