module Features
  module SessionHelpers
    def sign_in(user)
      visit login_path
      fill_in 'Email', with: user.email
      fill_in 'Password', with: "password"
      click_button 'Login'
    end

    def sign_out
      click_on "dropdownMenu2"
      click_on "sign-out"
    end
  end
end
