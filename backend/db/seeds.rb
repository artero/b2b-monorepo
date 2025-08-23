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

  # Create sample customers
  Customer.find_or_create_by!(code: 'ACME001') do |customer|
    customer.name = 'ACME Corporation'
    customer.email = 'contact@acme.com'
  end

  Customer.find_or_create_by!(code: 'TECH002') do |customer|
    customer.name = 'TechnoSoft Solutions'
    customer.email = 'info@technosoft.com'
  end

  Customer.find_or_create_by!(code: 'GLOBAL003') do |customer|
    customer.name = 'Global Industries'
    customer.email = nil  # Testing optional email
  end

  # Create sample customer users (without passwords initially)
  acme = Customer.find_by(code: 'ACME001')
  techno = Customer.find_by(code: 'TECH002')
  global = Customer.find_by(code: 'GLOBAL003')

  unless CustomerUser.exists?(email: 'john.doe@acme.com')
    CustomerUser.create_without_password(
      name: 'John',
      surname: 'Doe',
      phone_number: '+1234567890',
      email: 'john.doe@acme.com',
      customer: acme,
      blocked: false
    )
  end

  unless CustomerUser.exists?(email: 'jane.smith@technosoft.com')
    CustomerUser.create_without_password(
      name: 'Jane',
      surname: 'Smith',
      phone_number: '+0987654321',
      email: 'jane.smith@technosoft.com',
      customer: techno,
      blocked: false
    )
  end

  unless CustomerUser.exists?(email: 'blocked.user@global.com')
    CustomerUser.create_without_password(
      name: 'Blocked',
      surname: 'User',
      email: 'blocked.user@global.com',
      customer: global,
      blocked: true
    )
  end
end
