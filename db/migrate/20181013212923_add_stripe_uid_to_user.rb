class AddStripeUidToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :stripe_uid, :string
  end
end
