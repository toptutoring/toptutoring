class CreateAssignments < ActiveRecord::Migration[5.0]
  def change
    create_table :assignments do |t|
      t.references :tutor, index: true
      t.references :student, index: true
      t.string :state, default: "pending", null: false
      t.string :subject
      t.string :academic_type
      t.integer :hourly_rate
      t.timestamps
    end
  end
end
