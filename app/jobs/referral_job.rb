class ReferralJob < ActiveJob::Base
  queue_as :default

  def perform(id)
    @client = User.find(id)
    @referrer = @client.referrer
    return unless perform_referral_update
    UserNotifierMailer.send_referral_claimed_notice(@referrer, @client)
  end

  private 

  def perform_referral_update
    type = @referrer.client_account.highest_rate_type
    return unless type
    update_users(type + "_credit")
  end

  def update_users(credit_type)
    User.transaction do
      @referrer.send(credit_type + "=", @referrer.send(credit_type) + 1)
      @referrer.save!
      @client.referral_claimed = true
      @client.save!
    end
  rescue ActiveRecord::ActiveRecordError => e
    Bugsnag.notify("Referral Error\nReferrer: #{@referrer.full_name}\n" \
                   "User ID: #{@referrer.id}\nError: #{e}")
    false
  end
end
