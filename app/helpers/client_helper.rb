module ClientHelper
  def client_balance(client)
    if client.students.last&.engagement&.active?
      "#{client.balance / client.students.last.engagement.hourly_rate} hrs balance"
    end
  end
end
