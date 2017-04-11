class RemoveDirectorFromTutorInfo < ActiveRecord::Migration[5.0]
  def change
    remove_column :tutor_infos, :director
  end
end
