class AddPublishedToCity < ActiveRecord::Migration[5.1]
  def change
    add_column :cities, :published, :boolean, default: false
  end
end
