require "rails_helper"

describe CreditUpdater do
  let(:client) { FactoryGirl.create(:client_user) }
  let(:submitter)  { FactoryGirl.create(:tutor_user) }
  let(:engagement) { FactoryGirl.create(:engagement,
                                        client: client,
                                        tutor: submitter,
                                        student: FactoryGirl.create(:student_user, name: 'Something2')) }
  let(:invoice) { FactoryGirl.create(:invoice, client: client, submitter: submitter, engagement: engagement, hours: 2) }

  describe "#process_creation_of_invoice!" do
    it "Adjusts the client's balance down when a submitter's invoice is processed" do
      subject = CreditUpdater.new(invoice)
      hours = invoice.hours
      expect { subject.process_creation_of_invoice! }
        .to change { client.reload.test_prep_credit }.by(-hours)
    end

    it "Adjusts the submitter's balance up when a submitter's invoice is processed" do
      subject = CreditUpdater.new(invoice)
      hours = invoice.hours
      expect { subject.process_creation_of_invoice! }
        .to change { submitter.reload.outstanding_balance }.by(hours)
    end
  end

  describe "#process_payment_of_invoice!" do
    it "Adjusts the submitter's balance down when a submitter's invoice is processed" do
      subject = CreditUpdater.new(invoice)
      hours = invoice.hours
      expect { subject.process_payment_of_invoice! }
        .to change { submitter.reload.outstanding_balance }.by(-hours)
    end
  end

  describe "#update_existing_invoice" do
    context "when the new invoice is higher" do
      let(:new_params) { {hours: "5"} }
      it "Adjusts the client's balance down" do
        subject = CreditUpdater.new(invoice)
        new_hours = new_params["hours"].to_f
        old_hours = invoice.hours # 2 hours
        difference = new_hours - old_hours
        expect { subject.update_existing_invoice(new_params) }
          .to change { client.reload.test_prep_credit }.by(-3)
      end

      it "Adjusts the submitter's balance up" do
        subject = CreditUpdater.new(invoice)
        new_hours = new_params["hours"].to_f
        old_hours = invoice.hours # 2 hours
        difference = new_hours - old_hours
        expect { subject.update_existing_invoice(new_params) }
          .to change { submitter.reload.outstanding_balance }.by(3)
      end
    end

    context "when the new invoice is lower" do
      let(:new_params) { {hours: "1"} }
      it "Adjusts the client's balance up" do
        new_hours = new_params["hours"].to_f
        subject = CreditUpdater.new(invoice)
        old_hours = invoice.hours # 2 hours
        expect { subject.update_existing_invoice(new_params) }
          .to change { client.reload.test_prep_credit }.by(1)
      end

      it "Adjusts the submitter's balance down" do
        new_hours = new_params["hours"].to_f
        subject = CreditUpdater.new(invoice)
        old_hours = invoice.hours # 2 hours
        expect { subject.update_existing_invoice(new_params) }
          .to change { submitter.reload.outstanding_balance }.by(-1)
      end
    end
  end

  describe "#client_low_balance?" do
    it "returns false when client credit is over 0.5" do
      subject = CreditUpdater.new(invoice)
      expect(subject.client_low_balance?)
        .to be false
    end

    it "returns true when client credit is under 0.5" do
      client.update(test_prep_credit: 0)
      subject = CreditUpdater.new(invoice)
      expect(subject.client_low_balance?)
        .to be true
    end

    it "also works for academic_credit" do
      engagement.update(academic_type: 'Academic')
      client.update(test_prep_credit: 0)
      subject = CreditUpdater.new(invoice)
      expect(subject.client_low_balance?)
        .to be false
    end
  end
end
