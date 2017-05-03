require 'spec_helper'

feature "List all users" do
  before(:all) do
    set_roles
  end

  let(:admin) { FactoryGirl.create(:admin_user) }
  let(:student) { FactoryGirl.create(:student_user) }
  let(:tutor) { FactoryGirl.create(:tutor_user) }
  let(:client) { FactoryGirl.create(:client_user) }
  let(:director) { FactoryGirl.create(:director_user) }

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
      expect(page).to have_content("Roles")
      expect(page).to have_content("Action")

      expect(page).to have_content(student.name)
      expect(page).to have_content(student.email)
      expect(page).to have_content(student.phone_number)
      expect(page).to have_content(student.access_state)
      student.roles.distinct.pluck(:name).each do |role|
        expect(page).to have_content(role.humanize)
      end

      expect(page).to have_content(director.name)
      expect(page).to have_content(director.email)
      expect(page).to have_content(director.phone_number)
      expect(page).to have_content(director.access_state)
      director.roles.distinct.pluck(:name).each do |role|
        expect(page).to have_content(role.humanize)
      end

      expect(page).to have_content(tutor.name)
      expect(page).to have_content(tutor.email)
      expect(page).to have_content(tutor.phone_number)
      expect(page).to have_content(tutor.access_state)
      tutor.roles.distinct.pluck(:name).each do |role|
        expect(page).to have_content(role.humanize)
      end

      expect(page).to have_content(client.name)
      expect(page).to have_content(client.email)
      expect(page).to have_content(client.phone_number)
      expect(page).to have_content(client.access_state)
      student.roles.distinct.pluck(:name).each do |role|
        expect(page).to have_content(role.humanize)
      end

      sign_out
    end
  end
end
