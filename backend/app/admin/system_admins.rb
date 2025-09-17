ActiveAdmin.register AdminUser, as: "SystemAdmin" do
  permit_params :email, :password, :password_confirmation, :super_admin

  menu label: "System Admins", priority: 1

  index do
    selectable_column
    id_column
    column :email
    column :super_admin
    column :created_at
    actions
  end

  filter :email
  filter :super_admin
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  form do |f|
    f.inputs do
      f.input :email
      if f.object.new_record?
        f.input :password
        f.input :password_confirmation
      end
      f.input :super_admin
    end
    f.actions
  end
end
