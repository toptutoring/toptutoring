class AddDemoToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :demo, :boolean, default: false, null: false
  end
end
