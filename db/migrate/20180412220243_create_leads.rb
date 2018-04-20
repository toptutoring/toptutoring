class CreateLeads < ActiveRecord::Migration[5.1]
  def change
    create_table :leads do |t|
      t.string :email
      t.string :phone_number
      t.string :first_name
      t.string :last_name
      t.string :country_code
      t.references :subject
      t.text :comments
      t.integer :zip
      t.boolean :archived, default: false

      t.timestamps
    end
  end
end
