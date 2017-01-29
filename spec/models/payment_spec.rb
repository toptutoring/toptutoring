
RSpec.describe Payment, type: :model do
  context "#validations" do
    context "for dwolla payments" do
      let(:tutor) { FactoryGirl.create(:tutor_user) }
      let(:admin) { FactoryGirl.create(:admin_user) }

      it "can be created with all parameters" do
        payment = FactoryGirl.build(:payment, payee: tutor, payer: admin).save
        expect(payment).to be_truthy
      end

      it "cannot be created without payer" do
        payment = FactoryGirl.build(:payment, payer: nil).save
        expect(payment).not_to be_truthy
      end

      it "cannot be created without payee" do
        payment = FactoryGirl.build(:payment, source: "xxxx-xxx", payee: nil).save
        expect(payment).not_to be_truthy
      end

      it "cannot be created without amount or 0" do
        payment = FactoryGirl.build(:payment, payee: tutor, payer: admin, amount: nil).save
        expect(payment).not_to be_truthy
        payment = FactoryGirl.build(:payment, payee: tutor, payer: admin, amount: 0).save
        expect(payment).not_to be_truthy
      end
    end

    context "for stripe payments" do
      let(:parent) { FactoryGirl.create(:parent_user) }

      it "can be created with all parameters" do
        payment = FactoryGirl.build(:payment, payer: parent).save
        expect(payment).to be_truthy
      end

      it "cannot be created without payer" do
        payment = FactoryGirl.build(:payment, payer: nil).save
        expect(payment).not_to be_truthy
      end

      it "can be created without payee" do
        payment = FactoryGirl.build(:payment, payee: nil).save
        expect(payment).to be_truthy
      end

      it "cannot be created without amount or 0" do
        payment = FactoryGirl.build(:payment, payer: parent, amount: nil).save
        expect(payment).not_to be_truthy
        payment = FactoryGirl.build(:payment, payer: parent, amount: 0).save
        expect(payment).not_to be_truthy
      end

    end
  end

  context "#relationships" do
    let(:tutor)   { FactoryGirl.create(:tutor_user) }
    let(:admin)   { FactoryGirl.create(:admin_user) }
    let(:payment) { FactoryGirl.create(:payment, payee: tutor, payer: admin) }

    it "belong payee" do
      expect(payment.payee).to eq(tutor)
    end

    it "belong to payer" do
      expect(payment.payer).to eq(admin)
    end
  end
end
