ActiveAdmin.register AdminUser do
  permit_params :email, :password, :password_confirmation, :super_admin

  controller do
    before_action :require_super_admin, except: [ :index, :show ]

    private

    def require_super_admin
      redirect_to admin_root_path, alert: "Solo los superadmins pueden realizar esta acción" unless current_admin_user&.super_admin? || current_admin_user == resource
    end
  end

  index do
    selectable_column
    id_column
    column :email
    column :super_admin
    column :created_
    actions defaults: false do |admin_user|
      item I18n.t("active_admin.view"), admin_admin_user_path(admin_user), class: "member_link view_link"
      if current_admin_user&.super_admin? || current_admin_user == admin_user
        item I18n.t("active_admin.edit"), edit_admin_admin_user_path(admin_user), class: "member_link edit_link"
        item I18n.t("active_admin.delete"), admin_admin_user_path(admin_user), method: :delete,
             confirm: I18n.t("active_admin.delete_confirmation"), class: "member_link delete_link"
      end
    end
  end

  filter :email
  filter :super_admin
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_atSolo

  form do |f|
    f.inputs do
      f.input :email
      f.input :super_admin if current_admin_user&.super_admin?
    end
    f.actions
  end
end
