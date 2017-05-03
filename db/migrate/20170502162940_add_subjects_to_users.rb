class AddSubjectsToUsers < ActiveRecord::Migration[5.0]
  def change
    add_reference :subjects, :user, index: true, foreign_key: true
  end
end
