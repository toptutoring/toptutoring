class UpdateTokensWorker
  include Sidekiq::Worker
  sidekiq_options retry: 2

  def perform
    User.with_external_auth.each do |user|
      DwollaTokenRefresh.new(user.id).perform
    end
  end
end
