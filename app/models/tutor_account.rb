class TutorAccount < ApplicationRecord
  belongs_to :user
  has_many :engagements
  has_many :student_accounts, through: :engagements
  has_many :invoices, through: :engagements
  has_and_belongs_to_many :subjects
  has_one :contract, as: :account, dependent: :destroy
  has_many :payouts, as: :receiving_account

  monetize :online_rate_cents
  monetize :in_person_rate_cents

  validates_presence_of :user

  # clears join table
  before_destroy { subjects.clear }

  delegate :full_name, to: :user

  def balance_pending
    Money.new invoices.pending.sum(:submitter_pay_cents)
  end
end
