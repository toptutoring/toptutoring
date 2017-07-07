class CreateTimesheets < ActiveRecord::Migration[5.0]
  def change
    create_table :timesheets do |t|
      t.belongs_to :user
      t.integer :minutes
      t.text :description
      t.date :date
      t.string :status

      t.timestamps
    end
  end
end
