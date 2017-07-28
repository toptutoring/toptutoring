require "rails_helper"

describe DwollaTokenRefresh do
  let(:user) { FactoryGirl.create(:tutor_user) }
  let(:service) { DwollaTokenRefresh.new(user.id) }

  it 'refreshes valid tokens' do
    VCR.use_cassette('refresh dwolla tokens') do
      Timecop.freeze(Time.current) do
        service.perform
        user.reload
        expect(user.access_token).to eq("SPgfOVJVgARXDx8tLbzEOGiFJR82xhuTU6XsabNLFEEXcXxKvJ")
        expect(user.refresh_token).to eq("PMmp9SF1kD0B2Sen2HU092LPFumw3Ro6JAkyIWSHvQTJbYAY8k")
        expect(user.token_expires_at).to eq(Time.current.to_i + 3604)
      end
    end
  end
end
