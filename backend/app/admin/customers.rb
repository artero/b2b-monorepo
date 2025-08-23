ActiveAdmin.register Customer do
  permit_params :name, :code, :email

  # Menu configuration
  menu priority: 2, label: "Customers"

  # Filters
  filter :name
  filter :code
  filter :email
  filter :customer_users_name_or_customer_users_surname_cont, as: :string, label: "Customer User Name"
  filter :created_at
  filter :updated_at

  # Index page
  index title: "Customers" do
    selectable_column
    id_column
    column :name do |customer|
      link_to customer.name, admin_customer_path(customer)
    end
    column :code
    column :email do |customer|
      customer.email.presence || content_tag(:em, "No email", class: "empty")
    end
    column "Users", :customer_users_count do |customer|
      link_to customer.customer_users.count, admin_customer_users_path(q: { customer_id_eq: customer.id })
    end
    column :created_at, sortable: :created_at do |customer|
      l(customer.created_at, format: :short)
    end
    actions
  end

  # Show page
  show do
    attributes_table do
      row :id
      row :name
      row :code
      row :email do |customer|
        customer.email.presence || content_tag(:em, "No email")
      end
      row :created_at
      row :updated_at
    end

    panel "Customer Users" do
      table_for customer.customer_users do
        column :name do |user|
          link_to user.full_name, admin_customer_user_path(user)
        end
        column :email
        column :blocked do |user|
          status_tag(user.blocked? ? "Blocked" : "Active", user.blocked? ? :error : :ok)
        end
        column "Actions" do |user|
          link_to "View", admin_customer_user_path(user), class: "button"
        end
      end

      if customer.customer_users.empty?
        div class: "blank_slate_container" do
          span class: "blank_slate" do
            span "No Customer Users yet."
            br
            link_to "Create one", new_admin_customer_user_path(customer_user: { customer_id: customer.id }), class: "button"
          end
        end
      end
    end
  end

  # Form
  form do |f|
    f.semantic_errors(*f.object.errors.attribute_names)

    f.inputs "Customer Information" do
      f.input :name, required: true, hint: "Company or organization name"
      f.input :code, required: true, hint: "Unique customer code (e.g., ACME001)"
      f.input :email, hint: "Optional customer contact email"
    end

    f.actions
  end

  # Custom action to prevent deletion if has users
  controller do
    def destroy
      if resource.customer_users.any?
        flash[:error] = "Cannot delete customer with associated users. Please remove or reassign users first."
        redirect_to admin_customer_path(resource)
      else
        super
      end
    end
  end
end
