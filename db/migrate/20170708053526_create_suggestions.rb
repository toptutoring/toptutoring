class CreateSuggestions < ActiveRecord::Migration[5.0]
  def change
    create_table :suggestions do |t|
      t.belongs_to :engagement
      t.integer :suggested_minutes
      t.text :description
      t.text :status, default: "pending"
    end
  end
end
