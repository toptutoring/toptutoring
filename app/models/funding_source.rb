class FundingSource < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :funding_source_id

  def url
    "#{ENV.fetch('DWOLLA_API_URL')}/funding-sources/#{funding_source_id}"
  end
end
