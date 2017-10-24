class AddTutoringTypeToSubject < ActiveRecord::Migration[5.1]
  def change
    add_column :subjects, :tutoring_type, :string, default: 'academic'
  end
end
