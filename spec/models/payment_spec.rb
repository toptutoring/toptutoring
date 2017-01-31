
RSpec.describe Payment, type: :model do
  context "for dwolla tranfers" do
    before { allow(subject).to receive(:source).and_return('xxx') }
    it { should validate_presence_of(:payer_id) }
    it { should validate_numericality_of(:amount) }
    it { should_not allow_value(0).for(:amount) }
    it { should validate_presence_of(:payee_id) }
  end

  context "for stripe payments" do
    it { should validate_presence_of(:payer_id) }
    it { should_not validate_presence_of(:payee_id) }
    it { should validate_numericality_of(:amount) }
    it { should_not allow_value(0).for(:amount) }
  end

  context "#relationships" do
    before { allow(subject).to receive(:source).and_return('xxx') }
    it { should belong_to(:payer) }
    it { should belong_to(:payee) }
  end
end
