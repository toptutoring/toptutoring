class CreateRooms < ActiveRecord::Migration[5.1]
  def change
    create_table :rooms do |t|
      t.string :name
      t.integer :session_id
      t.integer :student_id
      t.integer :tutor_id
      t.string :student_token
      t.string :tutor_token

      t.timestamps
    end
    add_index :rooms, :student_id
    add_index :rooms, :tutor_id
  end
end
