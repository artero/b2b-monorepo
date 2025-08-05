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
  10.times do |i|
    AdminUser.find_or_create_by!(email: "admin_#{i}@example.com") do |user|
      user.password = 'password'
      user.password_confirmation = 'password'
      user.super_admin = false
    end
  end
end
