class CustomerUserMailer < ApplicationMailer
  default from: "noreply@company.com"

  # Send password generation instructions to customer user
  def password_generation_instructions(customer_user, token)
    @customer_user = customer_user
    @customer = customer_user.customer
    @token = token
    @reset_password_url = edit_customer_user_password_url(reset_password_token: @token)

    mail(
      to: @customer_user.email,
      subject: "Genera tu contraseña - Acceso al sistema"
    )
  end
end
