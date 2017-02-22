class CreateEmails < ActiveRecord::Migration[5.0]
  def change
    create_table :emails do |t|
      t.string :subject
      t.string :body
      t.timestamps
      t.references :tutor, index: true
      t.references :parent, index: true
    end
  end
end
