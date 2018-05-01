require "rails_helper"

describe DwollaMassPayUpdateService do
  subject = DwollaMassPayUpdateService
  dwolla_mass_pay_url = "a_unique_url"
  successful_uid = "successful_uid"
  failed_uid = "failed_uid"
  let(:payout_pending) { FactoryBot.create(:payout, status: "pending", destination: successful_uid) }
  let(:payout_paid) { FactoryBot.create(:payout, status: "paid", destination: failed_uid) }
  let(:payout_processing) { FactoryBot.create(:payout, status: "processing", dwolla_mass_pay_url: dwolla_mass_pay_url, destination: successful_uid) }
  let(:invoice) { FactoryBot.create(:invoice, status: "processing", payout: payout_processing) }
  let(:invoice2) { FactoryBot.create(:invoice, status: "processing", payout: payout_processing) }
  let(:payout_processing_failed) { FactoryBot.create(:payout, status: "processing", dwolla_mass_pay_url: dwolla_mass_pay_url, destination: failed_uid) }
  let(:invoice_failed) { FactoryBot.create(:invoice, status: "processing", payout: payout_processing_failed) }
  let(:payout_processing_unrelated) { FactoryBot.create(:payout, status: "processing") }
  let(:invoice_unrelated) { FactoryBot.create(:invoice, status: "processing", payout: payout_processing_unrelated) }
  let(:event) { FactoryBot.build(:dwolla_event, resource_url: dwolla_mass_pay_url) }

  describe ".perform!" do
    it "updates completed payout to paid without affecting unrelated payouts" do
      invoice
      invoice2
      invoice_failed

      success_url = "success_item_url"
      transfer_url = "transfer_url"
      failure_url = "failure_item_url"
      dwolla_stub_success([{ auth_uid: successful_uid, status: "success", item_url: success_url, transfer_url: transfer_url },
                           { auth_uid: failed_uid, status: "failed", item_url: failure_url }])
      subject.perform!(event)

      # all attributes related to mass pay item is updated
      expect(payout_processing.reload.dwolla_transfer_url).to eq transfer_url
      expect(payout_processing.dwolla_mass_pay_item_url).to eq success_url
      # failed items are recorded, user balance updated, and invoices set back to pending
      expect(payout_processing_failed.reload.dwolla_mass_pay_item_url).to eq failure_url
      expect(payout_processing_failed.status).to eq "failed"
      expect(invoice_failed.reload.status).to eq "pending"
    end

    it "does not change unrelated payouts and invoices" do
      invoice_attributes = invoice_unrelated.reload.attributes
      payout_attributes = payout_processing_unrelated.reload.attributes
      payout_paid_attributes = payout_paid.reload.attributes
      payout_pending_attributes = payout_pending.reload.attributes

      dwolla_stub_success([{ auth_uid: successful_uid }, { auth_uid: failed_uid }])
      subject.perform!(event)

      expect(invoice_unrelated.reload.attributes).to eq invoice_attributes
      expect(payout_processing_unrelated.reload.attributes).to eq payout_attributes
      expect(payout_paid.reload.attributes).to eq payout_paid_attributes
      expect(payout_pending.reload.attributes).to eq payout_pending_attributes
    end

    it "logs message if payout cannot be found" do
      payout_processing
      item_url = "item_url"
      dwolla_stub_success([{ auth_uid: failed_uid, item_url: item_url }])

      expect(Rails.logger).to receive(:warn).with("Unable to find payout for mass pay item #{item_url}.")
      
      subject.perform!(event)
    end
  end
end
