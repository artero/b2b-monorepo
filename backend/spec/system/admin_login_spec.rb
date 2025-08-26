require 'rails_helper'

RSpec.describe 'Admin Interface', type: :system do
  let(:admin_user) { create(:admin_user, password: 'password123', password_confirmation: 'password123') }

  describe 'Login functionality' do
    it 'can visit login page' do
      visit new_admin_user_session_path
      expect(page).to have_current_path(new_admin_user_session_path)
      expect(page).to have_content("Email")
    end
  end

  # describe 'Forgot password functionality' do
  #   it 'can access forgot password page directly' do
  #     visit new_admin_user_password_path
  #
  #     expect(page).to have_current_path(new_admin_user_password_path)
  #
  #     # Clear any existing emails
  #     ActionMailer::Base.deliveries.clear
  #
  #     fill_in "Email", with: admin_user.email
  #     click_button "Restablecer mi contraseña"
  #
  #     # Verify email was sent
  #     expect(ActionMailer::Base.deliveries.size).to eq(1)
  #
  #     email = ActionMailer::Base.deliveries.last
  #     expect(email.to).to eq([admin_user.email])
  #     expect(email.subject).to match(/(reset.*password|recuperación.*contraseña)/i)
  #     expect(email.body.to_s).to match(/(reset.*password|recuperación.*contraseña|restablecer)/i)
  #   end
  # end
end
