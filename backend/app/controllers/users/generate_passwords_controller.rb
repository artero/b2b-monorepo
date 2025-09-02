class Users::GeneratePasswordsController < ApplicationController
  before_action :find_user_by_token, only: [ :edit, :update ]

  def edit; end

  def update
    if @user.update(password_params)
      clear_reset_password_token
      Rails.logger.info("Password updated successfully for user #{@user.id}")
      flash[:notice] = I18n.t("users.generate_passwords.success")
      redirect_to generate_passwords_path
    else
      render :edit, status: :unprocessable_entity
    end
  rescue StandardError => e
    Rails.logger.error("Password update failed for user #{@user&.id}: #{e.message}")
    flash.now[:alert] = I18n.t("users.generate_passwords.error")
    render :edit, status: :unprocessable_entity
  end

  def show; end

  private

  def find_user_by_token
    token = params[:reset_password_token]

    unless token.present?
      flash[:alert] = I18n.t("users.generate_passwords.token_required")
      redirect_to generate_passwords_path
      return
    end

    @user = User.find_by(
      reset_password_token: Devise.token_generator.digest(User, :reset_password_token, token)
    )

    unless @user
      flash[:alert] = I18n.t("users.generate_passwords.invalid_token")
      redirect_to generate_passwords_path
      return
    end

    # Check if token has expired (using Devise configuration)
    if token_expired?
      flash[:alert] = I18n.t("users.generate_passwords.expired_token")
      redirect_to generate_passwords_path
      nil
    end
  end

  def token_expired?
    return false unless @user.reset_password_sent_at

    @user.reset_password_sent_at < Devise.reset_password_within.ago
  end

  def set_minimum_password_length
    User.password_length.min if User.respond_to?(:password_length)
  end

  def clear_reset_password_token
    @user.update_columns(
      reset_password_token: nil,
      reset_password_sent_at: nil,
      generated_password_at: Time.current
    )
  end

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def resource
    @user
  end

  def resource_name
    :user
  end

  helper_method :resource, :resource_name, :minimum_password_length
end
