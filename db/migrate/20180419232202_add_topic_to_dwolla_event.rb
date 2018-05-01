class AddTopicToDwollaEvent < ActiveRecord::Migration[5.1]
  def change
    add_column :dwolla_events, :topic, :string
    add_column :dwolla_events, :resource_url, :string
  end
end
