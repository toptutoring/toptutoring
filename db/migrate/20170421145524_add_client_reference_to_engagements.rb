class AddClientReferenceToEngagements < ActiveRecord::Migration[5.0]
  def change
    add_reference :engagements, :client, index: true
  end
end
