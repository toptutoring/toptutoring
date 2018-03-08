class AddDescriptionToTutorAccount < ActiveRecord::Migration[5.1]
  def change
    add_column :tutor_accounts, :description, :string
    add_column :tutor_accounts, :short_description, :string
    add_column :tutor_accounts, :profile_picture, :string
  end
end
