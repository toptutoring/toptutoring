module ParentHelper
  def parent_hourly_rate(parent)
    "#{parent.hourly_balance} hrs balance" if parent.hourly_balance
  end
end
