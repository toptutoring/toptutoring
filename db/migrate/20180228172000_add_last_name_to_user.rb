class AddLastNameToUser < ActiveRecord::Migration[5.1]
  class User < ApplicationRecord
    has_one :client_account, dependent: :destroy
    has_one :signup, dependent: :destroy
  end

  def up
    add_column :users, :last_name, :string
    delete_duplicate_user
    convert_names_into_first_and_last_name
    rename_column :users, :name, :first_name
  end

  def down
    rename_column :users, :first_name, :name
    revert_names
    remove_column :users, :last_name
  end

  private 

  def delete_duplicate_user
    User.where(email: "evani.williams.2006@gmail.com").each do |user|
      if user.destroy
        STDOUT.puts "User #{user.id} has been removed."
      else
        STDOUT.puts "User #{user.id} could not be removed."
      end
    end
  end

  def convert_names_into_first_and_last_name
    migrate_user_data("updated") do |user|
      name_array = user.name.split(" ")
      user.name = name_array[0]
      if name_array.count == 2
        user.last_name = name_array[1]
      elsif name_array.count > 2
        user.name = user.name.concat(" #{name_array[1]}")
        user.last_name = name_array[2]
      end
      user.save
    end
  end

  def revert_names
    migrate_user_data("reverted") do |user|
      user.name = "#{user.name} #{user.last_name}".strip
      user.save
    end
  end

  def migrate_user_data(action)
    User.reset_column_information
    User.find_each do |user|
      if yield(user)
        STDOUT.puts "User ##{user.id}'s name and last name has been #{action}."
      else
        STDOUT.puts "User ##{user.id}'s name and last name could not be #{action}. #{user.errors.full_messages.join(" ")}"
      end
    end
  end
end
