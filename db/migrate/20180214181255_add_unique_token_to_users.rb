class AddUniqueTokenToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :unique_token, :string
    add_index :users, :unique_token, unique: true
    create_unique_tokens_for_all_users
  end

  def create_unique_tokens_for_all_users
    User.reset_column_information
    User.all.find_each do |user|
      next if user.unique_token
      user.unique_token = SecureRandom.hex(3)
      if user.save
        STDOUT.puts "Added a unique token for user ##{user.id}."
      else
        STDOUT.puts "Unable to a unique token for user ##{user.id}."
      end
    end
  end
end
