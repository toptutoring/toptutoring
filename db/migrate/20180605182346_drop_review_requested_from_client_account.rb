class DropReviewRequestedFromClientAccount < ActiveRecord::Migration[5.1]
  def change
    remove_column :client_accounts, :review_requested, :boolean, default: false
  end
end
