class AddStripeAccountToPayment < ActiveRecord::Migration[5.1]
  def up
    add_reference :payments, :stripe_account, foreign_key: true
    add_column :payments, :stripe_source, :string
    transfer_data
    remove_column :payments, :customer_id
  end

  def down
    add_column :payments, :customer_id, :string
    revert_data
    remove_column :payments, :stripe_source
    remove_reference :payments, :stripe_account
  end

  private

  def transfer_data
    Payment.reset_column_information
    Payment.all.find_each do |payment|
      payment.stripe_account_id = User.find(payment.payer_id).stripe_account.try(:id)
      payment.stripe_source = payment.customer_id
      # must skip validations since new validations were added to payments.
      # old payments will not be able to be saved.
      payment.save(validate: false)
      STDOUT.puts "Updated data for payment ##{payment.id}."
    end
  end

  def revert_data
    Payment.reset_column_information
    Payment.all.find_each do |payment|
      payment.customer_id = payment.stripe_source
      # must skip validations since new validations were added to payments.
      # old payments will not be able to be saved.
      payment.save(validate: false)
      STDOUT.puts "Reverted data for payment ##{payment.id}."
    end
  end
end
