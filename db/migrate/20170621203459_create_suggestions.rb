class CreateSuggestions < ActiveRecord::Migration[5.0]
  def change
    create_table :suggestions do |t|
      t.integer :number_of_hours
      @client = User.find(@engagement.client_id)      t.references :engagement

      t.timestamps
    end
  end
end
