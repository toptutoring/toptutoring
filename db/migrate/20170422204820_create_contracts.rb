class CreateContracts < ActiveRecord::Migration[5.0]
  def change
    create_table :contracts do |t|
      t.decimal :hourly_rate, precision: 10, scale: 2, default: "0.0", null: false
      t.references :user, index: true, foreign_key: true
      t.timestamps
    end
  end
end
