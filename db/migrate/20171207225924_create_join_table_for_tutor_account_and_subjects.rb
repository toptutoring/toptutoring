class CreateJoinTableForTutorAccountAndSubjects < ActiveRecord::Migration[5.1]
  def change
    create_join_table :subjects, :tutor_accounts do |t|
      t.index :subject_id
      t.index :tutor_account_id
    end
  end
end
