class AddPictureToCity < ActiveRecord::Migration[5.1]
  def change
    add_column :cities, :picture, :string
  end
end
