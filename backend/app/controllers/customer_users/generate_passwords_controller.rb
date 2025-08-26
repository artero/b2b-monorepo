class CustomerUsers::GeneratePasswordsController < ApplicationController
  before_action :find_customer_user_by_token, only: [ :edit, :update ]

  def edit; end

  def update
    if @customer_user.update(password_params)
      clear_reset_password_token
      Rails.logger.info("Password updated successfully for customer_user #{@customer_user.id}")
      flash[:notice] = I18n.t("customer_users.generate_passwords.success")
      redirect_to generate_passwords_path
    else
      render :edit, status: :unprocessable_entity
    end
  rescue StandardError => e
    Rails.logger.error("Password update failed for customer_user #{@customer_user&.id}: #{e.message}")
    flash.now[:alert] = I18n.t("customer_users.generate_passwords.error")
    render :edit, status: :unprocessable_entity
  end

  def show; end

  private

  def find_customer_user_by_token
    token = params[:reset_password_token]

    unless token.present?
      flash[:alert] = I18n.t("customer_users.generate_passwords.token_required")
      redirect_to generate_passwords_path
      return
    end

    @customer_user = CustomerUser.find_by(
      reset_password_token: Devise.token_generator.digest(CustomerUser, :reset_password_token, token)
    )

    unless @customer_user
      flash[:alert] = I18n.t("customer_users.generate_passwords.invalid_token")
      redirect_to generate_passwords_path
      return
    end

    # Check if token has expired (using Devise configuration)
    if token_expired?
      flash[:alert] = I18n.t("customer_users.generate_passwords.expired_token")
      redirect_to generate_passwords_path
      nil
    end
  end

  def token_expired?
    return false unless @customer_user.reset_password_sent_at

    @customer_user.reset_password_sent_at < Devise.reset_password_within.ago
  end

  def set_minimum_password_length
    CustomerUser.password_length.min if CustomerUser.respond_to?(:password_length)
  end

  def clear_reset_password_token
    @customer_user.update_columns(
      reset_password_token: nil,
      reset_password_sent_at: nil,
      generated_password_at: Time.current
    )
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

  helper_method :resource, :resource_name, :minimum_password_length
end
