require 'rails_helper'

feature "Create payment for tutor" do
  let(:admin) { FactoryGirl.create(:auth_admin_user) }
  let(:tutor) { FactoryGirl.create(:tutor_user, outstanding_balance: 10) }
  let(:contract) { FactoryGirl.create(:contract, user_id: tutor.id) }
  let(:client_account) { FactoryGirl.create(:client_account) }
  let(:client) { client_account.user }
  let(:student_account) { FactoryGirl.create(:student_account, client_account: client_account) }
  let(:director) { FactoryGirl.create(:director_user, outstanding_balance: 10) }
  let(:funding_source) { FactoryGirl.create(:funding_source, user_id: admin.id) }

  context "when user is admin" do
    before do
      tutor
    end

    scenario "and does not have external auth" do
      sign_in(admin)
      visit admin_tutors_path
      click_on "Pay tutor"

      find('.tutor').find(:xpath, 'option[1]').select_option
      fill_in "payment_amount", with: 100
      fill_in "payment_description", with: "Admin Payment description"
      click_button "Send Payment"

      expect(page).to have_content("Funding source is not set. Please contact the administrator.")
    end

    scenario 'and has dwolla auth' do
      funding_source
      VCR.use_cassette('dwolla authentication', record: :new_episodes) do
        sign_in(admin)
        visit admin_tutors_path
        click_on "Pay tutor"

        find('.tutor').find(:xpath, 'option[2]').select_option
        fill_in "payment_amount", with: 15
        fill_in "payment_description", with: "Director Payment description"
        click_button "Send Payment"

        expect(page).to have_content('Payment is being processed.')
        # Standalone payment by admin does not take into account balances.
        expect(tutor.reload.outstanding_balance).to eq 10
      end
    end
  end

  context "when user is director" do
    context "and isn't paying himself" do
      let!(:engagement) { FactoryGirl.create(:engagement, student_account: student_account, tutor: tutor, client: client) }
      let!(:invoice) { FactoryGirl.create(:invoice, submitter: tutor, client: client, engagement: engagement, hours: 1) }

      scenario "and admin does not have external auth" do
        sign_in(director)
        visit admin_invoices_path

        click_on "Pay"

        expect(page).to have_content("Funding source is not set. Please contact the administrator.")
      end

      scenario "and admin has external auth" do
        funding_source
        VCR.use_cassette('dwolla authentication', record: :new_episodes) do
          sign_in(director)
          visit admin_invoices_path

          click_on "Pay"

          expect(page).to have_content('Payment is being processed.')
          expect(tutor.reload.outstanding_balance).to eq 9
        end
      end

      scenario "and payment exceeds tutor's balance" do
        VCR.use_cassette('dwolla authentication', record: :new_episodes) do
          tutor.update(outstanding_balance: 0)
          funding_source

          sign_in(director)
          visit admin_invoices_path
          click_on "Pay"

          expect(page).to have_content('This exceeds the maximum payment for this tutor.
          Please contact an administrator if you have any questions')
        end
      end
    end

    context "and is paying himself" do 
      scenario "with valid credentials" do
        VCR.use_cassette('dwolla authentication', record: :new_episodes) do
          director_engagement = FactoryGirl.create(:engagement, tutor: director, client: client, student_account: student_account)
          FactoryGirl.create(:invoice, submitter: director, client: client, engagement: director_engagement, hours: 1)
          funding_source

          sign_in(director)
          visit admin_invoices_path
          click_on "Pay"

          expect(page).to have_content('Payment is being processed.')
          expect(director.reload.outstanding_balance).to eq 9
        end
      end
    end
  end
end
