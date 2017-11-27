class AddSubjectToEngagements < ActiveRecord::Migration[5.1]
  class Engagement < ApplicationRecord
    def academic?
      academic_type == "Academic"
    end
  end

  class Subject < ApplicationRecord
    def academic_type
      tutoring_type == "academic" ? "Academic" : "Test Prep"
    end
  end

  def up
    add_reference :engagements, :subject

    update_engagement_data

    remove_column :engagements, :subject
    remove_column :engagements, :academic_type
  end

  def down
    add_column :engagements, :academic_type, :string
    add_column :engagements, :subject, :string

    revert_engagement_data

    remove_reference :engagements, :subject
  end

  def update_engagement_data
    Engagement.reset_column_information
    Engagement.all.find_each do |engagement|
      set_subject_for_engagement(engagement)
      if engagement.save
        STDOUT.puts "Updated engagement ##{engagement.id} to have subject ##{engagement.subject_id}"
      else
        STDOUT.puts "Failed to update engagement ##{engagement.id}."
      end
    end
  end

  def set_subject_for_engagement(engagement)
    subject = Subject.find_by_name(engagement.subject)
    if subject.nil?
      new_subject = find_subject_by_id_or_create(engagement)
      engagement.subject_id = new_subject.id
    else
      engagement.subject_id = subject.id
    end
  end

  def name_integer?(name)
    name == name.to_i.to_s
  end

  def find_subject_by_id_or_create(engagement)
    if name_integer?(engagement.subject)
      Subject.find(engagement.subject.to_i)
    else
      STDOUT.puts "Creating new subject with name #{engagement.subject}."
      Subject.where(name: engagement.subject).first_or_create
    end
  end

  def revert_engagement_data
    Engagement.reset_column_information
    Engagement.all.find_each do |engagement|
      subject = Subject.find engagement.subject_id
      if engagement.update(subject: subject, academic_type: subject.tutoring_type.humanize)
        STDOUT.puts "Reverted subject data for engagement ##{engagement.id}"
      else
        STDOUT.puts "Failed to revert subject data for engagement ##{engagement.id}"
      end
    end
  end
end
