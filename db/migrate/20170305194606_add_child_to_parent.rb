class AddChildToParent < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :parent_id, :integer
  end
end
