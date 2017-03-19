class ChangeParentReferencesToClient < ActiveRecord::Migration[5.0]
  def up
    rename_column :emails, :parent_id, :client_id
    rename_column :users, :parent_id, :client_id
    client = User.find_by_email("parent@example.com")
    client.update(email: "client@example.com") if client
  end

  def down
    rename_column :emails, :client_id, :parent_id
    rename_column :users, :client_id, :parent_id
    client = User.find_by_email("client@example.com")
    client.update(email: "parent@example.com") if client
  end
end
