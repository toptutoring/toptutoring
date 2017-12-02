class AddClientAccountReferenceToEngagement < ActiveRecord::Migration[5.1]
  class Engagement < ApplicationRecord
    belongs_to :client, class_name: "User", foreign_key: :client_id
    belongs_to :client_account
  end

  class User < ApplicationRecord
    has_many :engagements, foreign_key: :client_id
    has_one :client_account
  end

  class ClientAccount < ApplicationRecord
    belongs_to :user
    has_many :engagements
  end

  def up
    add_reference :engagements, :client_account
    associate_client_accounts_to_engagements
    remove_column :engagements, :client_id
  end

  def down
    add_column :engagements, :client_id, :integer
    restore_client_ids_to_engagements
    remove_reference :engagements, :client_account
  end

  def associate_client_accounts_to_engagements
    Engagement.reset_column_information
    Engagement.all.find_each do |engagement|
      engagement.update(client_account: engagement.client.client_account)
    end
  end

  def restore_client_ids_to_engagements
    Engagement.reset_column_information
    Engagement.all.find_each do |engagement|
      engagement.update(client: engagement.client_account.user)
    end
  end
end
