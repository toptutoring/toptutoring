require "rails_helper"

feature "Create payment for tutor" do
  let(:admin) { FactoryBot.create(:auth_admin_user) }
  let(:tutor) { FactoryBot.create(:tutor_user, outstanding_balance: 10) }
  let(:contract) { FactoryBot.create(:contract, user_id: tutor.id) }
  let(:client) { FactoryBot.create(:client_user) }
  let(:student_account) { FactoryBot.create(:student_account, client_account: client.client_account) }
  let(:director) { FactoryBot.create(:director_user, outstanding_balance: 10) }
  let(:funding_source) { FactoryBot.create(:funding_source, user_id: admin.id) }

  context "when user is admin" do
    before do
      tutor
    end

    scenario "and does not have external auth" do
      sign_in(admin)
      visit admin_tutors_path
      click_on "Pay tutor"

      find(".tutor").find(:xpath, "option[1]").select_option
      fill_in "payout_amount", with: 100
      fill_in "payout_description", with: "Payment for tutoring X hours"
      click_button "Send Payment"

      expect(page).to have_content("Funding source is not set. Please contact the administrator.")
    end

    scenario "and has dwolla auth" do
      funding_source
      VCR.use_cassette("dwolla authentication", record: :new_episodes) do
        sign_in(admin)
        visit admin_tutors_path
        click_on "Pay tutor"

        find(".tutor").find(:xpath, "option[2]").select_option
        fill_in "payout_amount", with: 15
        fill_in "payout_description", with: "Payment for tutoring X hours"
        click_button "Send Payment"

        expect(page).to have_content("Payment is being processed.")
        # Standalone payment by admin does not take into account balances.
        expect(tutor.reload.outstanding_balance).to eq 10
      end
    end
  end

  context "when user is director" do
    context "and isn't paying himself" do
      let!(:engagement) { FactoryBot.create(:engagement, student_account: student_account, tutor_account: tutor.tutor_account, client_account: client.client_account) }
      let!(:invoice) { FactoryBot.create(:invoice, submitter: tutor, client: client, engagement: engagement, hours: 1) }

      scenario "and admin does not have external auth" do
        sign_in(director)
        visit admin_invoices_path

        click_on "Pay"

        expect(page).to have_content("Funding source is not set. Please contact the administrator.")
      end

      scenario "and admin has external auth" do
        funding_source
        VCR.use_cassette("dwolla authentication", record: :new_episodes) do
          sign_in(director)
          visit admin_invoices_path

          click_on "Pay"

          expect(page).to have_content("Payment is being processed.")
          expect(tutor.reload.outstanding_balance).to eq 9
        end
      end

      scenario "and payment exceeds tutor's balance" do
        VCR.use_cassette("dwolla authentication", record: :new_episodes) do
          tutor.update(outstanding_balance: 0)
          funding_source

          sign_in(director)
          visit admin_invoices_path
          click_on "Pay"

          expect(page).to have_content("This exceeds the maximum payment for this tutor.
          Please contact an administrator if you have any questions")
        end
      end
    end

    context "and is paying himself" do 
      scenario "with valid credentials" do
        VCR.use_cassette("dwolla authentication", record: :new_episodes) do
          director_engagement = FactoryBot.create(:engagement, tutor_account: director.tutor_account, client_account: client.client_account, student_account: student_account)
          FactoryBot.create(:invoice, submitter: director, client: client, engagement: director_engagement, hours: 1)
          funding_source

          sign_in(director)
          visit admin_invoices_path
          click_on "Pay"

          expect(page).to have_content("Payment is being processed.")
          expect(director.reload.outstanding_balance).to eq 9
        end
      end
    end
  end
end
