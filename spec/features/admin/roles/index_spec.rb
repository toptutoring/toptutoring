require "rails_helper"

feature "Admin role features" do
  let(:contractor) { FactoryBot.create(:contractor_user) }
  let(:tutor) { FactoryBot.create(:tutor_user) }
  let(:director) { FactoryBot.create(:director_user) }
  let(:admin) { FactoryBot.create(:auth_admin_user) }

  let(:director_role) { Role.find_by_name("director") }
  let(:tutor_role) { Role.find_by_name("tutor") }
  let(:contractor_role) { Role.find_by_name("contractor") }

  scenario "when admin visits roles page and there are no users without roles" do
    contractor
    tutor
    director

    sign_in(admin)
    visit admin_roles_path

    expect(page).to have_content("Directors")
    expect(page).to have_content("Tutors")
    expect(page).to have_content("Contractors")
    expect(page).to have_content("Remove as Director")
    expect(page).to have_content("Remove as Tutor")
    expect(page).to have_content("Remove as Contractor")
    expect(page).to have_content("Add as contractor")
    expect(page).to have_content("Add as director")
    expect(page).not_to have_content("Unassigned Users")
  end

  scenario "when admin visits roles page and there are users without roles" do
    tutor
    director
    contractor.roles = []
    contractor.contractor_account.destroy

    sign_in(admin)
    visit admin_roles_path

    expect(page).to have_content("Unassigned Users")
  end

  scenario "when admin removes roles" do
    contractor
    tutor
    director
    
    sign_in(admin)

    visit admin_roles_path

    expect(director.roles).to include(director_role)
    click_on "Remove as Director"
    expect(director.reload.roles.empty?).to be true

    expect(tutor.roles).to include(tutor_role)
    click_on "Remove as Tutor"
    expect(tutor.reload.roles.empty?).to be true
    expect(tutor.reload.tutor_account).to be nil

    expect(contractor.roles).to include(contractor_role)
    click_on "Remove as Contractor"
    expect(contractor.reload.roles.empty?).to be true
    expect(contractor.reload.tutor_account).to be nil
  end

  scenario "when admin adds contractor and director roles" do
    tutor
    sign_in(admin)

    visit admin_roles_path

    expect(tutor.roles).to contain_exactly(tutor_role)
    expect(tutor.contractor_account).to be nil
    click_on "Add as contractor"
    expect(tutor.reload.roles).to contain_exactly(tutor_role, contractor_role)
    expect(tutor.reload.contractor_account).to be_truthy
    expect(tutor.reload.contractor_account.contract).to be_truthy

    click_on "Add as director"
    expect(tutor.reload.roles).to contain_exactly(tutor_role, contractor_role, director_role)
  end

  scenario "when admin adds tutor role" do
    contractor.roles = []
    contractor.contractor_account.destroy
    sign_in(admin)

    visit admin_roles_path

    expect(contractor.roles.empty?).to be true
    expect(contractor.tutor_account).to be nil
    click_on "Add as tutor"
    expect(contractor.reload.roles).to contain_exactly(tutor_role)
    expect(contractor.reload.tutor_account).to be_truthy
    expect(contractor.reload.tutor_account.contract).to be_truthy
  end
end
