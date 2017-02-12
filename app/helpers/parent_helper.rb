module ParentHelper
  def parent_balance(parent)
    if parent.assignment && parent.assignment.active?
      "#{parent.balance / parent.assignment.hourly_rate} hrs balance"
    end
  end
end
