class AddZipToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :zip, :integer
  end
end
