require "rails_helper"

feature "Tutor Payouts Page" do
  let(:tutor) { FactoryBot.create(:tutor_user, stripe_uid: "something") }

  scenario 'when user is tutor' do
    sign_in(tutor)
    visit tutors_payouts_path

    expect(page).to have_content('Payout method')
    expect(page).to have_content('Currency')
  end
end
