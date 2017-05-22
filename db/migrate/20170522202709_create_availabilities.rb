class CreateAvailabilities < ActiveRecord::Migration[5.0]
  def change
    create_table :availabilities do |t|
      t.datetime :from
      t.datetime :to
      t.references :engagement, index: true, foreign_key: true
    end
  end
end
