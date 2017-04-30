class MonetizeClientRate < ActiveRecord::Migration[5.0]
  def change
    add_monetize :users, :academic_rate, amount: { :default => 2999 }
    add_monetize :users, :test_prep_rate, amount: { :default => 5999 }
  end
end
