class CreateClientInfo < ActiveRecord::Migration[5.0]
  def change
    create_table :client_infos do |t|
      t.string :subject
      t.integer :tutoring_for
      t.references :user, index: true, foreign_key: true
    end
  end
end
