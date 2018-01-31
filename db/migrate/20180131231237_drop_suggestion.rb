class DropSuggestion < ActiveRecord::Migration[5.1]
  def change
    drop_table :suggestions
  end
end
