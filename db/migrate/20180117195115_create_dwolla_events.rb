class CreateDwollaEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :dwolla_events do |t|
      t.string :event_id

      t.timestamps
    end
  end
end
