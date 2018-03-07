class DataMigrationForErroneousPaymentAmount < ActiveRecord::Migration[5.1]
  class Payment < ApplicationRecord
    monetize :amount_cents
  end

  def up
    payment = Payment.find_by(id: 12)
    return unless payment
    payment.amount = payment.amount / 100
    update_payment(payment, "correct")
  end

  def down
    payment = Payment.find_by(id: 12)
    return unless payment
    payment.amount = payment.amount * 100
    update_payment(payment, "revert")
  end

  def update_payment(payment, action)
    if payment.save
      STDOUT.puts "Payment with id #{payment.id} was #{action}ed."
    else
      STDOUT.puts "Payment with id #{payment.id} was unable to be #{action}ed."
    end
  end
end
