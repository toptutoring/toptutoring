class FundingSource < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :funding_source_id
end
