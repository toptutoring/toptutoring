require "rails_helper"

describe CreditUpdater do
  let(:client) { FactoryGirl.create(:client_user) }
  let(:tutor)  { FactoryGirl.create(:tutor_user) }
  let(:engagement) { FactoryGirl.create(:engagement,
                                        client: client,
                                        tutor: tutor,
                                        student: FactoryGirl.create(:student_user, name: 'Something2')) }
  let(:invoice) { FactoryGirl.create(:invoice, client: client, tutor: tutor, engagement: engagement, hours: 2) }

    describe "#process!" do
      it "Adjusts the client's balance down when a tutor's invoice is processed" do
        subject = CreditUpdater.new(invoice.id)
        hours = invoice.hours
        expect { subject.process! }
          .to change { client.reload.test_prep_credit }.by(-hours)
      end

      it "Adjusts the tutor's balance up when a tutor's invoice is processed" do
        subject = CreditUpdater.new(invoice.id)
        hours = invoice.hours
        expect { subject.process! }
          .to change { tutor.reload.outstanding_balance }.by(hours)
      end
    end

   describe "#update_existing_invoice" do
     context "when the new invoice is higher" do
       it "Adjusts the client's balance down" do
         new_hours = 5
         subject = CreditUpdater.new(invoice.id, new_hours)
         old_hours = invoice.hours # 2 hours
         difference = new_hours - old_hours
         expect { subject.update_existing_invoice }
           .to change { client.reload.test_prep_credit }.by(-3)
       end

       it "Adjusts the tutor's balance up" do
         new_hours = 5
         subject = CreditUpdater.new(invoice.id, new_hours)
         old_hours = invoice.hours # 2 hours
         difference = new_hours - old_hours
         expect { subject.update_existing_invoice }
           .to change { tutor.reload.outstanding_balance }.by(3)
       end
     end
    context "when the new invoice is lower" do
      it "Adjusts the client's balance up" do
        new_hours = 1
        subject = CreditUpdater.new(invoice.id, new_hours)
        old_hours = invoice.hours # 2 hours
        expect { subject.update_existing_invoice }
          .to change { client.reload.test_prep_credit }.by(1)
      end

      it "Adjusts the tutor's balance down" do
        new_hours = 1
        subject = CreditUpdater.new(invoice.id, new_hours)
        old_hours = invoice.hours # 2 hours
        expect { subject.update_existing_invoice }
          .to change { tutor.reload.outstanding_balance }.by(-1)
      end
    end
   end
end
