module Features
  module RolesHelpers
    def set_roles
      FactoryGirl.create(:role, name: "admin")
      FactoryGirl.create(:role, name: "director")
      FactoryGirl.create(:role, name: "tutor")
      FactoryGirl.create(:role, name: "client")
      FactoryGirl.create(:role, name: "student")
    end
  end
end
