module ClientHelper
  def client_balance(client)
    if client.assignment && client.assignment.active?
      "#{client.balance / client.assignment.hourly_rate} hrs balance"
    end
  end
end
