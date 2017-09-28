class BalanceAdjuster
  class << self
    def lower_balance_and_update(user, object_to_update)
      user.outstanding_balance -= object_to_update.hours
      object_to_update.status = 'paid'
      ActiveRecord::Base.transaction do
        user.save!
        object_to_update.save!
      end
    end
  end
end
