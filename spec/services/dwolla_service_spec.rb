require "rails_helper"

describe DwollaService do
  subject = DwollaService
  let(:admin) { FactoryBot.create(:auth_admin_user) }

  describe ".refresh_token!" do
    it "refreshes valid tokens" do
      VCR.use_cassette("refresh dwolla tokens") do
        Timecop.freeze(Time.current) do
          subject.refresh_token!(admin)
          admin.reload
          expect(admin.access_token).to eq("7TNx9RHIQs2EBbP47mKENaVRzBO7rke9DduE52FxP3zKPuuqzt")
          expect(admin.refresh_token).to eq("QgpHipjUMQDcn3xVKgn9vhRtWMoXQkfuamg4h699y5BpaAOB3S")
          expect(admin.token_expires_at).to eq(Time.current.to_i + 3607)
        end
      end
    end
  end
end
