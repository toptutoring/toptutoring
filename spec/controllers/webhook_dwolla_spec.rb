require "rails_helper"

describe Webhooks::DwollaController do
  subject = Webhooks::DwollaController
  describe "#update" do
    before :each do
      allow(controller).to receive(:verify_signature).and_return(true)
    end 

    it "skips action if already processed" do
      event_id = "an_id"
      FactoryBot.create(:dwolla_event, event_id: event_id)

      post :update, params: { id: event_id, _links: { resource: { href: "url" } }, topic: "transfer_failed" }

      expect(response).to have_http_status(:already_reported)
    end

    it "processes failed transfer if not already processed" do
      dwolla_service = class_double("DwollaCompleteTransferService").as_stubbed_const
      expect(dwolla_service).to(receive(:perform!)).and_return(true)

      expect {
        post :update, params: { id: "event_id", _links: { resource: { href: "url" } }, topic: "transfer_failed" }
      }.to change(DwollaEvent, :count).by 1
    end

    it "processes completed transfer if not already processed" do
      dwolla_service = class_double("DwollaCompleteTransferService").as_stubbed_const
      expect(dwolla_service).to(receive(:perform!)).and_return(true)

      expect {
        post :update, params: { id: "event_id", _links: { resource: { href: "url" } }, topic: "transfer_completed" }
      }.to change(DwollaEvent, :count).by 1
    end

    it "processes mass pay update if not already processed" do
      dwolla_service= class_double("DwollaMassPayUpdateService").as_stubbed_const
      expect(dwolla_service).to(receive(:perform!)).and_return(true)

      expect {
        post :update, params: { id: "event_id", _links: { resource: { href: "url" } }, topic: "mass_payment_completed" }
      }.to change(DwollaEvent, :count).by 1
    end
  end

  describe "#verify_signature" do
    it "prevents process of request if not verified" do
      request.headers["X-Request-Signature-Sha-256"] = "signature"
      post :update, body: "test"
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
