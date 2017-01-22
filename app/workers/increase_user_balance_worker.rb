class IncreaseUserBalanceWorker
  include Sidekiq::Worker

  def perform(amount, user_id)
    set_user(user_id)
    update_user_balance(amount, @user)
  end

  private

  def update_user_balance(amount, user)
    user.balance += amount
    user.save!
  end

  def set_user(user_id)
    @user ||= User.find(user_id)
  end
end
