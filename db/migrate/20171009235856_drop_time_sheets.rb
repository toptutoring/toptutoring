class DropTimeSheets < ActiveRecord::Migration[5.1]
  class Timesheet < ApplicationRecord
    belongs_to :user
  end

  class Invoice < ApplicationRecord
    belongs_to :submitter, class_name: "User"
    enum submitter_type: [:by_tutor, :by_contractor]
    monetize :submitter_pay_cents
  end

  def up
    Invoice.reset_column_information
    Timesheet.find_each do |timesheet|
      submitter = timesheet.user
      hours = timesheet.minutes / 60.0
      invoice = Invoice.create(hours: hours,
                               status: timesheet.status || 'paid',
                               submitter: submitter,
                               description: timesheet.description,
                               submitter_pay: submitter.contract.hourly_rate * hours,
                               submitter_type: 'by_contractor')
      STDOUT.puts "Converted timsheet id #{timesheet.id} into invoice id #{invoice.id}"
    end

    drop_table :timesheets
  end

  def down
    create_table :timesheets do |t|
      t.integer :minutes
      t.references :user
      t.text :description
      t.string :status

      t.timestamps
    end

    Invoice.by_contractor.find_each do |invoice|
      timesheet = Timesheet.create(user: invoice.submitter,
                                   minutes: invoice.hours * 60,
                                   status: invoice.status,
                                   description: invoice.description)
      STDOUT.puts "Converted invoice id #{invoice.id} into timesheet id #{timesheet.id}"
      invoice.destroy
    end
  end
end
