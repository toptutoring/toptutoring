class ChangeTutoringTypeToAcademicTypeForSubject < ActiveRecord::Migration[5.1]
  def change
    rename_column :subjects, :tutoring_type, :academic_type
  end
end
