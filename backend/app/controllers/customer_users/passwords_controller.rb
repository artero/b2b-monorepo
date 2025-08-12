class CustomerUsers::PasswordsController < Devise::PasswordsController
  # Override the edit action to ensure it uses our custom view
  def edit
    super
  end

  # Override the update action to customize the password reset process
  def update
    super
  end

  # Override to redirect to custom success page after password reset
  def after_resetting_password_path_for(resource)
    # Redirect to a success page or login page
    new_customer_user_session_path
  end

  protected

  # The path used after sending reset password instructions
  def after_sending_reset_password_instructions_path_for(resource_name)
    new_customer_user_session_path
  end
end