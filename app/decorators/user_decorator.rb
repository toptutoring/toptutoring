class UserDecorator < Draper::Decorator
  def hourly_balance
    object.balance.to_f / object.assignment.hourly_rate
  end
end
