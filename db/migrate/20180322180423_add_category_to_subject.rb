class AddCategoryToSubject < ActiveRecord::Migration[5.1]
  def change
    add_column :subjects, :category, :string
  end
end
