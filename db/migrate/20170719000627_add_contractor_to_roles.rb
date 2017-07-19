class AddContractorToRoles < ActiveRecord::Migration[5.0]
  def up
    execute "INSERT INTO roles (name) VALUES ('contractor');"
  end

  def down
    execute "DELETE FROM roles WHERE name = 'contractor';"
  end
end
