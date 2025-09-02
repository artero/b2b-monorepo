require 'rails_helper'

RSpec.describe UserMailer, type: :mailer do
  describe "#password_generation_instructions" do
    let(:user) { create(:user) }
    let(:token) { "sample-token" }
    let(:mail) { UserMailer.password_generation_instructions(user, token) }

    it "has correct subject" do
      expect(mail.subject).to eq("Genera tu contraseña - Acceso al sistema")
    end

    it "sends to correct recipient" do
      expect(mail.to).to eq([ user.email ])
    end

    it "sends from correct sender" do
      expect(mail.from).to eq([ "noreply@company.com" ])
    end

    it "includes expected content" do
      expect(mail.body.encoded).to match(/Estimado cliente/)
      expect(mail.body.encoded).to match(token)
      expect(mail.body.encoded).to match(/European Aerosols/)
      expect(mail.body.encoded).to match(/marketing@novasolspray.com/)
      expect(mail.body.encoded).to match(/24/)
    end

    it "does not include unwanted content" do
      expect(mail.body.encoded).not_to match(/Pintyplus/)
    end
  end
end
