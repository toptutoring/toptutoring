class CreateStudents < ActiveRecord::Migration[5.0]
  def change
    create_table :students do |t|
      t.string :name
      t.string :email
      t.string :phone_number
      t.string :subject
      t.string :academic_type
      t.references :user, index: true, foreign_key: true
    end
  end
end
