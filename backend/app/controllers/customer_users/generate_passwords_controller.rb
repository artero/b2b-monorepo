class CustomerUsers::GeneratePasswordsController < ApplicationController
  before_action :find_custumer_user_by_token, only: [:edit, :update]

  def edit
    @minimum_password_length = CustomerUser.password_length.min if CustomerUser.respond_to?(:password_length)
  end

  def update
    if @customer_user.update(password_params)
      # Clear the reset password token after successful password update
      @customer_user.update_columns(
        reset_password_token: nil, 
        reset_password_sent_at: nil,
        generated_password_at: Time.current
      )
      flash[:notice] = "Contraseña actualizada correctamente."

      redirect_to generate_passwords_path
    else
      @minimum_password_length = CustomerUser.password_length.min if CustomerUser.respond_to?(:password_length)
      render :edit, status: :unprocessable_entity
    end
  end

  def show
  end

  private

  def find_custumer_user_by_token
    token = params[:reset_password_token]
    
    unless token.present?
      flash[:alert] = "Token de restablecimiento de contraseña requerido."
      redirect_to generate_passwords_path
      return
    end

    @customer_user = CustomerUser.find_by(reset_password_token: Devise.token_generator.digest(CustomerUser, :reset_password_token, token))
    
    unless @customer_user
      flash[:alert] = "Token de restablecimiento de contraseña inválido o expirado."
      redirect_to generate_passwords_path
      return
    end

    # Check if token has expired (24 hours)
    if @customer_user.reset_password_sent_at && @customer_user.reset_password_sent_at < 7.days.ago
      flash[:alert] = "El enlace de restablecimiento de contraseña ha expirado."
      redirect_to generate_passwords_path
      return
    end
  end

  def password_params
    params.require(:customer_user).permit(:password, :password_confirmation)
  end

  def resource
    @customer_user
  end

  def resource_name
    :customer_user
  end
  helper_method :resource, :resource_name
end

