class CreateTutors < ActiveRecord::Migration[5.0]
  def change
    create_table :tutors do |t|
      t.string :subject
      t.string :academic_type
      t.references :user, index: true, foreign_key: true
    end
  end
end
