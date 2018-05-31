require "rails_helper"

describe DwollaService do
  subject = DwollaService
  let(:admin) { User.admin }
  let(:tutor) { FactoryBot.create(:tutor_user) }
  let(:funding_source) { FactoryBot.create(:funding_source) }

  describe ".refresh_token!" do
    it "refreshes valid tokens" do
      VCR.use_cassette("dwolla refresh token") do
        admin
        subject.refresh_token!(admin)
        admin.reload
        expect(admin.access_token).to eq("dTsd6O5v9ZowPpCiXFWXO21PZ3KR1Em8alkRTK9EpYWVPvMzDZ")
        expect(admin.refresh_token).to eq("hrJywggNipumNq3TuW8fHJ5wOgypXsctUR1ZfLKakX3C4FA8Ul")
      end
    end
  end

  describe ".request" do
    it "returns mass pay url for mass_payment" do
      VCR.use_cassette("dwolla mass pay") do
        admin
        tutor
        funding_source
        payouts = { _links: { destination: { href: "#{ENV.fetch('DWOLLA_API_URL')}/accounts/#{tutor.auth_uid}" } },
                    amount: { currency: "USD", value: "10.00" },
                    metadata: { auth_uid: tutor.auth_uid, payee_id: tutor.id, approver_id: admin.id, description: "Test" } }

        payload = { _links: { source: { href: funding_source.url } }, items: [payouts] }

        request = subject.request(:mass_payment, payload)

        expect(request.success?).to eq true
      end
    end

    it "returns transfer url for single payment" do
      VCR.use_cassette("dwolla single payment") do
        admin
        funding_source
        payload = { _links: { destination: { href: "#{ENV.fetch('DWOLLA_API_URL')}/accounts/#{tutor.auth_uid}" }, 
                              source: { href: "#{ENV.fetch('DWOLLA_API_URL')}/funding-sources/#{funding_source.funding_source_id}" } },
                    amount: { currency: "USD", value: "10.00" },
                    metadata: { concept: "Test" } }

        request = subject.request(:transfer, payload)

        expect(request.success?).to eq true
      end
    end

    it "returns funding sources" do
      VCR.use_cassette("dwolla funding sources") do
        request = subject.request(:funding_sources, admin)

        expect(request.success?).to eq true
      end
    end

    it "returns list of mass payment items" do
      VCR.use_cassette("dwolla mass pay items") do
        admin
        request = subject.request(:mass_pay_items, "https://api-sandbox.dwolla.com/mass-payments/02941cff-210e-429c-8ad1-a86c00719bc6")

        expect(request.success?).to eq true
      end
    end
  end
end
