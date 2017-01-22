class UpdateUserBalance
  def initialize(amount, user_id)
    @amount = amount
    @user_id = user_id
  end

  def increase
    user.balance += @amount
    user.save!
  end

  def decrease
    user.balance -= @amount
    user.save!
  end

  private

  def user
    @user ||= User.find(@user_id)
  end
end
