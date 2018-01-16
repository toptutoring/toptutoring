class CreateCities < ActiveRecord::Migration[5.1]
  def change
    create_table :cities do |t|
      t.string :name
      t.string :country
      t.string :state
      t.string :phone_number
      t.text :description

      t.timestamps
    end
  end
end
