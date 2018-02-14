class CreateClientReviews < ActiveRecord::Migration[5.1]
  def change
    create_table :client_reviews do |t|
      t.references :client_account, foreign_key: true
      t.text :review
      t.integer :stars
      t.boolean :permission_to_publish

      t.timestamps
    end
  end
end
