require "rails_helper"

def phone(number)
  Phonelib.parse(number, :us).national
end

feature "List all users" do
  let(:admin) { User.admin }
  let(:student) { FactoryBot.create(:student_user) }
  let(:tutor) { FactoryBot.create(:tutor_user) }
  let(:client) { FactoryBot.create(:client_user) }
  let(:director) { FactoryBot.create(:director_user) }

  context "when user is admin" do
    scenario "should see user info" do
      director
      student
      tutor
      client

      sign_in(admin)

      visit admin_users_path

      expect(page).to have_content("Name")
      expect(page).to have_content("Email")
      expect(page).to have_content("Date Added")
      expect(page).to have_content("Access State")
      expect(page).to have_content("Action")

      expect(page).to have_content(student.full_name)
      expect(page).to have_content(student.email)
      expect(page).to have_content(phone(student.phone_number))
      expect(page).to have_content(student.access_state)
      student.roles.distinct.pluck(:name).each do |role|
        expect(page).to have_content(role.humanize)
      end
      expect(page).to have_link("masquerade_link_#{student.id}")

      expect(page).to have_content(director.full_name)
      expect(page).to have_content(director.email)
      expect(page).to have_content(phone(director.phone_number))
      expect(page).to have_content(director.access_state)
      director.roles.distinct.pluck(:name).each do |role|
        expect(page).to have_content(role.humanize)
      end
      expect(page).to have_link("masquerade_link_#{director.id}")

      expect(page).to have_content(tutor.full_name)
      expect(page).to have_content(tutor.email)
      expect(page).to have_content(phone(tutor.phone_number))
      expect(page).to have_content(tutor.access_state)
      tutor.roles.distinct.pluck(:name).each do |role|
        expect(page).to have_content(role.humanize)
      end
      expect(page).to have_link("masquerade_link_#{tutor.id}")

      expect(page).to have_content(client.full_name)
      expect(page).to have_content(client.email)
      expect(page).to have_content(phone(client.phone_number))
      expect(page).to have_content(client.access_state)
      client.roles.distinct.pluck(:name).each do |role|
        expect(page).to have_content(role.humanize)
      end
      expect(page).to have_link("masquerade_link_#{client.id}")

      sign_out
    end
  end
end
