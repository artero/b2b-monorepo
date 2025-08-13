class CustomerUserMailer < ApplicationMailer
  default from: "noreply@company.com"

  def password_generation_instructions(customer_user, token)
    @customer_user = customer_user
    @customer = customer_user.customer
    @token = token
    @generate_password_url = edit_generate_passwords_url(reset_password_token: @token)

    mail(
      to: @customer_user.email,
      subject: "Genera tu contraseña - Acceso al sistema"
    )
  end
end
