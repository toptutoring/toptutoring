class AddReferredByToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :referrer_id, :integer
    add_column :users, :referral_claimed, :boolean, default: false
  end
end
