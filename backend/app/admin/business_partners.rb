ActiveAdmin.register BusinessPartner do
  permit_params :name, :ln_id, :email

  # Menu configuration
  menu priority: 2, label: "Business Partners"

  # Filters
  filter :name
  filter :ln_id
  filter :email
  filter :users_name_or_users_surname_cont, as: :string, label: "User Name"
  filter :created_at
  filter :updated_at

  # Index page
  index title: "Business Partners" do
    selectable_column
    id_column
    column :name do |business_partner|
      link_to business_partner.name, admin_business_partner_path(business_partner)
    end
    column :ln_id
    column :email do |business_partner|
      business_partner.email.presence || content_tag(:em, "No email", class: "empty")
    end
    column "Users", :users_count do |business_partner|
      link_to business_partner.users.count, admin_users_path(q: { business_partner_id_eq: business_partner.id })
    end
    column :created_at, sortable: :created_at do |business_partner|
      l(business_partner.created_at, format: :short)
    end
    actions
  end

  # Show page
  show do
    attributes_table do
      row :id
      row :name
      row :ln_id
      row :email do |business_partner|
        business_partner.email.presence || content_tag(:em, "No email")
      end
      row :created_at
      row :updated_at
    end

    panel "Users" do
      table_for business_partner.users do
        column :name do |user|
          link_to user.full_name, admin_user_path(user)
        end
        column :email
        column :blocked
        column "Actions" do |user|
          link_to "View", admin_user_path(user), class: "button"
        end
      end

      if business_partner.users.empty?
        div class: "blank_slate_container" do
          span class: "blank_slate" do
            span "No Users yet."
            br
            link_to "Create one", new_admin_user_path(user: { business_partner_id: business_partner.id }), class: "button"
          end
        end
      end
    end
  end

  # Form
  form do |f|
    f.semantic_errors(*f.object.errors.attribute_names)

    f.inputs "Business Partner Information" do
      f.input :name, required: true, hint: "Company or organization name"
      f.input :ln_id, required: true, hint: "Unique business partner identifier (e.g., ACME001)"
      f.input :email, hint: "Optional business partner contact email"
    end

    f.actions
  end

  # Custom action to prevent deletion if has users
  controller do
    def destroy
      if resource.users.any?
        flash[:error] = "Cannot delete business partner with associated users. Please remove or reassign users first."
        redirect_to admin_business_partner_path(resource)
      else
        super
      end
    end
  end
end
