class DropPayeeApproverFromPayment < ActiveRecord::Migration[5.1]
  class Payout < ApplicationRecord; end
  class Payment < ApplicationRecord; end
  class FundingSource < ApplicationRecord; end

  def up
    count = Payment.count
    create_payouts_from_payments
    raise "Counts do not match" if count != Payment.count + Payout.count
    remove_column :payments, :approver_id
    remove_column :payments, :payee_id
    remove_column :payments, :source
    remove_column :payments, :destination
    remove_column :payments, :external_code
  end

  def down
    count = Payment.count + Payout.count
    add_column :payments, :approver_id, :integer
    add_column :payments, :payee_id, :integer, index: true
    add_column :payments, :source, :string
    add_column :payments, :destination, :string
    add_column :payments, :external_code, :string
    revert_payment_data_from_payouts
    raise "Counts do not match" if count != Payment.count + Payout.count
  end

  private

  def create_payouts_from_payments
    Payment.where.not(payee_id: nil).find_each do |payment|
      payout = new_payout(payment)
      save_and_destroy(payout, payment)
    end
  end

  def new_payout(payment)
    account_info = find_account(payment)
    Payout.new(amount_cents: payment.amount_cents,
               description: payment.description,
               destination: payment.destination || User.find(payment.payee_id).auth_uid,
               dwolla_transfer_url: payment.external_code,
               status: payment.status,
               funding_source: payment.source || FundingSource.last.funding_source_id,
               approver_id: payment.payer_id || User.admin.id,
               receiving_account_id: account_info[:account_id],
               receiving_account_type: account_info[:account_type])
  end

  def find_account(payment)
    user = User.find(payment.payee_id)
    if user.contractor_account
      type = "ContractorAccount"
      account_id = user.contractor_account.id
    else
      type = "TutorAccount"
      account_id = user.tutor_account.id
    end
    { account_id: account_id, account_type: type }
  end

  def save_and_destroy(save, destroy)
    if save.save
      STDOUT.puts "Created #{save.class} ##{save.id}."
      destroy.destroy!
    else
      STDOUT.puts "Failed to create new #{save.class}. " \
                  "#{save.errors.full_messages} " \
                  "Keeping #{destroy.class} ##{destroy.id}."
    end
  end

  def revert_payment_data_from_payouts
    Payout.all.find_each do |payout|
      payment = old_payment(payout)
      save_and_destroy(payment, payout)
    end
  end

  def old_payment(payout)
    Payment.reset_column_information
    Payment.new(amount_cents: payout.amount_cents,
                description: payout.description,
                destination: payout.destination,
                external_code: payout.dwolla_transfer_url,
                status: payout.status,
                source: payout.source,
                payer_id: payout.approver_id,
                payee_id: find_payee_id(payout))
  end

  def find_payee_id(payout)
    if payout.receiving_account_type == "ContractorAccount"
      account = ContractorAccount.find(payout.receiving_account_id)
    else
      account = TutorAccount.find(payout.receiving_account_id)
    end
    account.user_id
  end
end
