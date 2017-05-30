class CreateFeedbacks < ActiveRecord::Migration[5.0]
  def change
    create_table :feedbacks do |t|
      t.text :comments
      t.references :user, index: true, foreign_key: true
      t.timestamps
    end
  end
end
