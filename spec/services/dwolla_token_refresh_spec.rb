require "rails_helper"

describe DwollaTokenRefresh do
  let(:user) { FactoryGirl.create(:tutor_user) }
  let(:service) { DwollaTokenRefresh.new(user.id) }

  it 'refreshes valid tokens' do
    VCR.use_cassette('refresh dwolla tokens') do
      Timecop.freeze(Time.current) do
        service.perform
        user.reload
        expect(user.access_token).to eq("7TNx9RHIQs2EBbP47mKENaVRzBO7rke9DduE52FxP3zKPuuqzt")
        expect(user.refresh_token).to eq("QgpHipjUMQDcn3xVKgn9vhRtWMoXQkfuamg4h699y5BpaAOB3S")
        expect(user.token_expires_at).to eq(Time.current.to_i + 3607)
      end
    end
  end
end
