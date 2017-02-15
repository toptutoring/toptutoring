class CreateFundingSources < ActiveRecord::Migration[5.0]
  def change
    create_table :funding_sources do |t|
      t.string :funding_source_id
      t.references :user, index: true
    end
  end
end
