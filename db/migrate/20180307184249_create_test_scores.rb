class CreateTestScores < ActiveRecord::Migration[5.1]
  def change
    create_table :test_scores do |t|
      t.string :score
      t.string :badge
      t.references :subject, foreign_key: true
      t.references :tutor_account, foreign_key: true

      t.timestamps
    end
  end
end
