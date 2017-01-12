class AddStateToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :access_state, :string, default: "disabled", null: false
  end
end
