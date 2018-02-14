class AddReviewRequestedToClientAccounts < ActiveRecord::Migration[5.1]
  def change
    add_column :client_accounts, :review_requested, :boolean, default: false
  end
end
