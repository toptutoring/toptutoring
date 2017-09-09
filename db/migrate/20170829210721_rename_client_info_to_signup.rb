class RenameClientInfoToSignup < ActiveRecord::Migration[5.1]
  def change
    rename_table :client_infos, :signups
  end
end
