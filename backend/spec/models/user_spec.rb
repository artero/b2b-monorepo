require 'rails_helper'

RSpec.describe User, type: :model do
  describe "#full_name" do
    it "returns concatenated name and surname" do
      user = create(:user, name: "John", surname: "Doe")
      expect(user.full_name).to eq("John Doe")
    end

    it "strips whitespace" do
      user = create(:user, name: "  Alice  ", surname: "  Brown  ")

      expect(user.full_name).to eq("Alice Brown")
    end

    it "handles empty name" do
      user = build_stubbed(:user, name: "", surname: "Johnson")
      expect(user.full_name).to eq("Johnson")
    end

    it "handles empty surname" do
      user = build_stubbed(:user, name: "Bob", surname: "")
      expect(user.full_name).to eq("Bob")
    end
  end

  describe "#generated_password_at" do
    it "is present when password was generated" do
      user = create(:user)
      expect(user.generated_password_at).not_to be_nil
      expect(user.generated_password_at).to be < Time.current
    end

    it "is nil when password was not generated" do
      user = create(:user, :blocked)
      expect(user.generated_password_at).to be_nil
    end

    it "tracks recent password generation" do
      user = create(:user, :recently_generated_password)
      expect(user.generated_password_at).not_to be_nil
    end
  end

  describe "#send_password_generation_instructions" do
    it "generates token and sets timestamp" do
      user = create(:user, :blocked)

      expect(user.reset_password_token).to be_nil
      expect(user.reset_password_sent_at).to be_nil

      result = user.send_password_generation_instructions

      expect(result).to be_truthy
      expect(user.reset_password_token).not_to be_nil
      expect(user.reset_password_sent_at).not_to be_nil
      expect(user.generated_password_at).to be_nil
      expect(user.reset_password_sent_at).to be <= Time.now.utc
      expect(user.reset_password_sent_at).to be >= 1.minute.ago.utc
    end

    it "sends email" do
      user = create(:user, :blocked)

      expect {
        user.send_password_generation_instructions
      }.to change { ActionMailer::Base.deliveries.size }.by(1)
    end

    it "returns false on validation error" do
      user = create(:user, :blocked)
      user.email = nil

      result = user.send_password_generation_instructions

      expect(result).to be_falsey
    end

    it "clears generated_password_at" do
      user = create(:user)
      expect(user.generated_password_at).not_to be_nil

      user.send_password_generation_instructions
      user.reload

      expect(user.generated_password_at).to be_nil
    end
  end

  describe "token validation" do
    it "is valid within 24 hours" do
      user = create(:user, :blocked)
      user.send_password_generation_instructions

      # Simulate token generated 23 hours ago
      user.update_column(:reset_password_sent_at, 23.hours.ago)

      # Token should still be valid
      expect(user.reset_password_sent_at).to be >= Devise.reset_password_within.ago
    end

    it "expires after 24 hours" do
      user = create(:user, :blocked)
      user.send_password_generation_instructions

      # Simulate token generated 25 hours ago
      user.update_column(:reset_password_sent_at, 25.hours.ago)

      # Token should be expired
      expect(user.reset_password_sent_at).to be < Devise.reset_password_within.ago
    end
  end
end
