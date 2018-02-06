class CreateStripeAccounts < ActiveRecord::Migration[5.1]
  def up
    create_table :stripe_accounts do |t|
      t.string :customer_id
      t.references :user, foreign_key: true

      t.timestamps
    end
    tranfer_customer_ids
    remove_column :users, :customer_id
  end

  def down
    add_column :users, :customer_id, :string
    revert_customer_ids
    drop_table :stripe_accounts
  end

  private

  def tranfer_customer_ids
    User.where.not(customer_id: nil).find_each do |user|
      account = StripeAccount.new(customer_id: user.customer_id, user_id: user.id)
      if account.save
        STDOUT.puts "Created a new StripeAccount for user #{user.id}."
      else
        STDOUT.puts "Unable to create StripeAccount for user #{user.id}."
      end
    end
  end

  def revert_customer_ids
    User.reset_column_information
    StripeAccount.all.find_each do |account|
      user = User.find(account.user_id)
      user.customer_id = account.customer_id
      if user.save
        STDOUT.puts "Deleted StripeAccount for user ##{user.id}."
      else
        STDOUT.puts "Unable to delete StripeAccount for user #{user.id}."
      end
    end
  end
end
