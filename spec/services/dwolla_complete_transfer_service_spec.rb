require "rails_helper"

describe DwollaCompleteTransferService do
  subject = DwollaCompleteTransferService
  dwolla_transfer_url = "a_unique_url"
  let(:payout_pending) { FactoryBot.create(:payout, status: "pending") }
  let(:payout_paid) { FactoryBot.create(:payout, status: "paid") }
  let(:payout_processing) { FactoryBot.create(:payout, status: "processing", dwolla_transfer_url: dwolla_transfer_url) }
  let(:invoice) { FactoryBot.create(:invoice, status: "processing", payout: payout_processing) }
  let(:invoice2) { FactoryBot.create(:invoice, status: "processing", payout: payout_processing) }
  let(:payout_processing_unrelated) { FactoryBot.create(:payout, status: "processing") }
  let(:invoice_unrelated) { FactoryBot.create(:invoice, status: "processing", payout: payout_processing_unrelated) }

  describe ".perform!" do
    it "updates completed payout to paid without affecting unrelated payouts" do
      payout_pending
      payout_paid
      invoice
      invoice2
      invoice_unrelated

      subject.perform!(dwolla_transfer_url, "paid")

      # all items related to transfer is updated
      expect(payout_processing.reload.status).to eq "paid"
      expect(invoice.reload.status).to eq "paid"
      expect(invoice2.reload.status).to eq "paid"
      # all items not related are not updated
      expect(payout_pending.reload.status).to eq "pending"
      expect(payout_paid.reload.status).to eq "paid"
      expect(payout_processing_unrelated.reload.status).to eq "processing"
      expect(invoice_unrelated.reload.status).to eq "processing"
    end

    it "updates canceled payout to failed without affecting unrelated payouts" do
      payout_pending
      payout_paid
      invoice
      invoice2
      invoice_unrelated

      subject.perform!(dwolla_transfer_url, "failed")

      hours = invoice.hours + invoice2.hours
      # all items related to transfer is updated
      expect(payout_processing.reload.status).to eq "failed"
      expect(invoice.reload.status).to eq "pending"
      expect(invoice2.reload.status).to eq "pending"
      # canceled payout returns balance to user
      expect(payout_processing.payee.outstanding_balance).to eq hours
      # all items not related are not updated
      expect(payout_pending.reload.status).to eq "pending"
      expect(payout_paid.reload.status).to eq "paid"
      expect(payout_processing_unrelated.reload.status).to eq "processing"
      expect(invoice_unrelated.reload.status).to eq "processing"
    end

    it "logs message if payout doesn't exit" do
      expect(Rails.logger).to receive(:info).with("Could not find processing payout with transfer url: #{dwolla_transfer_url}")

      subject.perform!(dwolla_transfer_url, "paid")
    end

    it "logs message if payout is already paid" do
      payout_processing.update(status: "paid")
      expect(Rails.logger).to receive(:info).with("Payout #{payout_processing.id} is not processing. Current status: #{payout_processing.status}.")
      
      subject.perform!(dwolla_transfer_url, "paid")
    end
  end
end
