class CreateNotifications < ActiveRecord::Migration[5.1]
  def change
    create_table :notifications do |t|
      t.string :message_type
      t.string :title
      t.string :message
      t.boolean :read, default: false
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
