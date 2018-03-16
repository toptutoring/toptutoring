class AddPublishtoTutorAccount < ActiveRecord::Migration[5.1]
  def change
    add_column :tutor_accounts, :publish, :boolean, default: false
  end
end
