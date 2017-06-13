class CreateCards < ActiveRecord::Migration[5.0]
  def change
    create_table :credit_cards do |t|
      t.string :customer_id
      t.boolean :confirmed, default: false
      t.boolean :primary, default: false
      t.references :user, index: true, foreign_key: true
    end
  end
end
