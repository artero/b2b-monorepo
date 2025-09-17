# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
if Rails.env.development?
  AdminUser.find_or_create_by!(email: 'admin@example.com') do |user|
    user.password = 'password'
    user.password_confirmation = 'password'
    user.super_admin = true
  end

  # create 10 AdminUser records
  5.times do |i|
    AdminUser.find_or_create_by!(email: "admin_#{i}@example.com") do |user|
      user.password = 'password'
      user.password_confirmation = 'password'
      user.super_admin = false
    end
  end

  5.times do |i|
    AdminUser.find_or_create_by!(email: "superadmin_#{i}@example.com") do |user|
      user.password = 'password'
      user.password_confirmation = 'password'
      user.super_admin = true
    end
  end

  # Create sample business partners
  BusinessPartner.find_or_create_by!(ln_id: 'ACME001') do |business_partner|
    business_partner.name = 'ACME Corporation'
    business_partner.email = 'contact@acme.com'
  end

  BusinessPartner.find_or_create_by!(ln_id: 'TECH002') do |business_partner|
    business_partner.name = 'TechnoSoft Solutions'
    business_partner.email = 'info@technosoft.com'
  end

  BusinessPartner.find_or_create_by!(ln_id: 'GLOBAL003') do |business_partner|
    business_partner.name = 'Global Industries'
    business_partner.email = nil  # Testing optional email
  end

  # Create sample users (without passwords initially)
  acme = BusinessPartner.find_by(ln_id: 'ACME001')
  techno = BusinessPartner.find_by(ln_id: 'TECH002')
  global = BusinessPartner.find_by(ln_id: 'GLOBAL003')

  unless User.exists?(email: 'john.doe@acme.com')
    User.create_without_password(
      name: 'John',
      surname: 'Doe',
      phone_number: '+1234567890',
      email: 'john.doe@acme.com',
      business_partner: acme,
      blocked: false
    )
  end

  unless User.exists?(email: 'jane.smith@technosoft.com')
    User.create_without_password(
      name: 'Jane',
      surname: 'Smith',
      phone_number: '+0987654321',
      email: 'jane.smith@technosoft.com',
      business_partner: techno,
      blocked: false
    )
  end

  unless User.exists?(email: 'blocked.user@global.com')
    User.create_without_password(
      name: 'Blocked',
      surname: 'User',
      email: 'blocked.user@global.com',
      business_partner: global,
      blocked: true
    )
  end
end

# Create admin user for production
if Rails.env.production?
  admin_email = ENV.fetch('ADMIN_EMAIL', 'admin@example.com')
  admin_password = ENV.fetch('ADMIN_PASSWORD', 'changeme123!')

  AdminUser.find_or_create_by!(email: admin_email) do |user|
    user.password = admin_password
    user.password_confirmation = admin_password
    user.super_admin = true
  end

  puts "✅ Admin user created: #{admin_email}"
end
