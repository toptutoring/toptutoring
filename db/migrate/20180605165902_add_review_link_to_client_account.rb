class AddReviewLinkToClientAccount < ActiveRecord::Migration[5.1]
  def change
    add_column :client_accounts, :review_source, :string
    add_column :client_accounts, :review_link, :string
  end
end
