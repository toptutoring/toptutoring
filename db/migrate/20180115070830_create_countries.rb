class CreateCountries < ActiveRecord::Migration[5.1]
  def change
    create_table :countries do |t|
      t.string :code
      t.string :name

      t.timestamps
    end
    add_reference :cities, :country, foreign_key: true
  end
end
