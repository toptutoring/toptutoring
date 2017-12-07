class AddTutorAccountReferenceToEngagement < ActiveRecord::Migration[5.1]
  def up
    add_reference :engagements, :tutor_account
    add_tutor_account_to_engagements
    remove_column :engagements, :tutor_id
  end

  def down
    add_column :engagements, :tutor_id, :integer
    revert_data_for_engagements
    remove_reference :engagements, :tutor_account
  end

  def add_tutor_account_to_engagements
    Engagement.reset_column_information
    Engagement.all.find_each do |engagement|
      next if engagement.tutor_id.nil?
      tutor = User.find(engagement.tutor_id)
      engagement.tutor_account_id = TutorAccount.find_by(user_id: tutor.id).id
      if engagement.save
        STDOUT.puts "Added tutor account to engagement #{engagement.id}."
      else
        STDOUT.puts "Failed to add tutor account to engagement #{engagement.id}."
      end
    end
  end

  def revert_data_for_engagements
    Engagement.reset_column_information
    Engagement.all.find_each do |engagement|
      next if engagement.tutor_account_id.nil?
      tutor_id = TutorAccount.find(engagement.tutor_account_id).user_id
      engagement.tutor_id = tutor_id
      if engagement.save
        STDOUT.puts "Reverted tutor data for engagement #{engagement.id}."
      else
        STDOUT.puts "Failed to revert tutor data for engagement #{engagement.id}."
      end
    end
  end
end
