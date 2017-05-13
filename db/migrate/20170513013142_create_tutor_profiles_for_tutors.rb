class CreateTutorProfilesForTutors < ActiveRecord::Migration[5.0]
  def change
    remove_column :subjects, :user_id
    create_table :tutor_profiles do |t|
      t.references :user, index: true
      t.references :subject, index: true
    end
  end
end
