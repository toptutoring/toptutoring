class AddReviewLinkToClientReview < ActiveRecord::Migration[5.1]
  def change
    add_column :client_reviews, :review_link, :string
    add_column :client_reviews, :review_source, :string
  end
end
