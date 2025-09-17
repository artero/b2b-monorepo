require 'rails_helper'

RSpec.describe 'Admin Users Management', type: :system do
  let(:super_admin) { create(:admin_user, :super_admin, password: 'password123', password_confirmation: 'password123') }

  it 'admin can access admin users section after login' do
    visit new_admin_user_session_path

    fill_in "Email", with: super_admin.email
    fill_in "Contraseña", with: "password123"
    click_button "Iniciar Sesión"

    expect(page).to have_current_path(admin_root_path)

    visit admin_system_admins_path

    expect(page).to have_current_path(admin_system_admins_path)
    expect(page).to have_content("System Admins")
  end
end
