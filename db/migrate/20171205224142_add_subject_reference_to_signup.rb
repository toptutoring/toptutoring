class AddSubjectReferenceToSignup < ActiveRecord::Migration[5.1]
  class Subject < ApplicationRecord; end
  class Signup < ApplicationRecord; end

  def up
    add_reference :signups, :subject
    add_subject_association_to_sign_up
    remove_column :signups, :subject
  end

  def down
    add_column :signups, :subject, :string
    revert_subject_data
    remove_reference :signups, :subject
  end

  private

  def add_subject_association_to_sign_up
    Signup.reset_column_information
    Signup.all.find_each do |signup|
      subject = find_subject_by_id_or_name(signup.subject)
      signup.subject_id = subject.id
      save_data("update", signup)
    end
  end

  def revert_subject_data
    Signup.reset_column_information
    Signup.all.find_each do |signup|
      signup.subject = Subject.find(signup.subject_id).name
      save_data("revert", signup)
    end
  end

  def find_subject_by_id_or_name(subject)
    if number?(subject)
      subject = Subject.find(subject)
    else
      subject = Subject.find_by_name(subject)
    end
    subject ? subject : Subject.first
  end

  def number?(subject)
    subject.to_i.to_s == subject
  end

  def save_data(method, signup)
    if signup.save
      STDOUT.puts "Successfully #{method}d subject data for signup #{signup.id}."
    else
      STDOUT.puts "Failed to #{method} subject data for signup #{signup.id}."
    end
  end
end
