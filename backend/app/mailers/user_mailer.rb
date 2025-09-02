class UserMailer < ApplicationMailer
  default from: "noreply@company.com"

  def password_generation_instructions(user, token)
    @user = user
    @business_partner = user.business_partner
    @token = token
    @generate_password_url = edit_generate_passwords_url(reset_password_token: @token)

    mail(
      to: @user.email,
      subject: "Genera tu contraseña - Acceso al sistema"
    )
  end
end
