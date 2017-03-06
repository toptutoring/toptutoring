class FundingSource < ActiveRecord::Base
  validates_presence_of :funding_source_id
end
