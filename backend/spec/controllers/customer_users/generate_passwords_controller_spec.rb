require 'rails_helper'

RSpec.describe CustomerUsers::GeneratePasswordsController, type: :controller do
  describe "GET #edit" do
    context "with expired token" do
      it "redirects with error" do
        user = create(:customer_user, :blocked)
        user.send_password_generation_instructions

        # Create a raw token for testing
        raw_token = Devise.friendly_token
        hashed_token = Devise.token_generator.digest(CustomerUser, :reset_password_token, raw_token)

        # Set expired timestamp (25 hours ago)
        user.update_columns(
          reset_password_token: hashed_token,
          reset_password_sent_at: 25.hours.ago
        )

        get :edit, params: { reset_password_token: raw_token }

        expect(response).to redirect_to(generate_passwords_path)
        expect(flash[:alert]).to match(/ha expirado/)
      end
    end

    context "with valid token within 24 hours" do
      it "allows access" do
        user = create(:customer_user, :blocked)
        user.send_password_generation_instructions

        # Create a raw token for testing
        raw_token = Devise.friendly_token
        hashed_token = Devise.token_generator.digest(CustomerUser, :reset_password_token, raw_token)

        # Set valid timestamp (23 hours ago)
        user.update_columns(
          reset_password_token: hashed_token,
          reset_password_sent_at: 23.hours.ago
        )

        get :edit, params: { reset_password_token: raw_token }

        expect(response).to be_successful
        expect(flash[:alert]).to be_nil
      end
    end
  end
end
