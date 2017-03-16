
RSpec.describe Payment, type: :model do
  FactoryGirl.create(:role)
  context "for dwolla transfers" do
    before {
      allow(subject).to receive(:source).and_return('xxx')
      allow(subject).to receive(:payee).and_return(FactoryGirl.create(:tutor_user))
    }
    it { should belong_to(:payer) }
    it { should belong_to(:payee) }
    it { should validate_presence_of(:payer_id) }
    it { should validate_presence_of(:payee_id) }
    it { should validate_numericality_of(:amount) }
    it { should_not allow_value(0).for(:amount) }
  end

  context "for logged in stripe payments" do
    before { allow(subject).to receive(:customer_id).and_return('xxx') }
    it { should belong_to(:payer) }
    it { should validate_presence_of(:payer_id) }
    it { should_not validate_presence_of(:payee_id) }
    it { should validate_numericality_of(:amount) }
    it { should_not allow_value(0).for(:amount) }
  end

  context "for anonymous stripe payments" do
    it { should_not validate_presence_of(:payer_id) }
    it { should_not validate_presence_of(:payee_id) }
    it { should validate_numericality_of(:amount) }
    it { should_not allow_value(0).for(:amount) }
  end
end
