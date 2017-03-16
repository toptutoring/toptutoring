module ClientHelper
  def client_balance(client)
    if client.students.last.assignment&.active?
      "#{client.balance / client.students.last.assignment.hourly_rate} hrs balance"
    end
  end
end
