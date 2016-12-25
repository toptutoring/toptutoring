class CreateTutors < ActiveRecord::Migration[5.0]
  def change
    create_table :tutors do |t|
      t.string :subject, null: false
      t.string :activity_type, null: false
      t.references :user, index: true, foreign_key: true
    end
  end
end
