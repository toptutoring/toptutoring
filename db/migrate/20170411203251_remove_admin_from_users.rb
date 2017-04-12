class RemoveAdminFromUsers < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :demo
    remove_column :users, :admin
  end
end
