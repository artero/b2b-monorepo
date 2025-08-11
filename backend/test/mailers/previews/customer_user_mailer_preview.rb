# Preview all emails at http://localhost:3000/rails/mailers/customer_user_mailer
class CustomerUserMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/customer_user_mailer/password_generation_instructions
  def password_generation_instructions
    CustomerUserMailer.password_generation_instructions
  end
end
