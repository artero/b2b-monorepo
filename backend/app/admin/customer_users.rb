ActiveAdmin.register CustomerUser do
  permit_params :name, :surname, :phone_number, :email, :customer_id, :blocked

  # Menu configuration
  menu priority: 3, label: "Customer Users"

  # Scopes for filtering
  scope :all, default: true
  scope :active, -> { CustomerUser.active }
  scope :blocked, -> { CustomerUser.blocked }

  # Filters
  filter :customer, as: :select, collection: -> { Customer.order(:name) }
  filter :name
  filter :surname
  filter :email
  filter :phone_number
  filter :blocked
  filter :created_at
  filter :updated_at

  # Index page
  index title: "Customer Users" do
    selectable_column
    column :name do |user|
      link_to user.full_name, admin_customer_user_path(user)
    end
    column :email
    column :customer do |user|
      link_to user.customer.name, admin_customer_path(user.customer)
    end
      column :blocked
    column :created_at, sortable: :created_at do |user|
      l(user.created_at, format: :short)
    end
    actions do |user|
      unless user.encrypted_password.present?
        item "Generate Password", generate_password_admin_customer_user_path(user),
             method: :post, class: "button",
             data: { confirm: "Send password generation email to #{user.email}?" }
      end
    end
  end

  # Show page
  show do
    attributes_table do
      row :id
      row :name
      row :surname
      row :full_name
      row :email
      row :phone_number
      row :customer do |user|
        link_to user.customer.name, admin_customer_path(user.customer)
      end
      row :blocked do |user|
        # status_tag(user.blocked? ? "Blocked" : "Active", user.blocked? ? "error" : "ok")
      end
      row "Password Status" do |user|
        # if user.encrypted_password.present?
        #   status_tag "Password Set", "ok"
        # else
        #   status_tag "Password Pending", "warning"
        # end
      end
      row :reset_password_sent_at do |user|
        user.reset_password_sent_at&.strftime("%B %d, %Y at %I:%M %p")
      end
      row :created_at
      row :updated_at
    end

    panel "Actions" do
      div do
        unless resource.encrypted_password.present?
          link_to "Generate Password", generate_password_admin_customer_user_path(resource),
                  method: :post, class: "button",
                  data: { confirm: "Send password generation email to #{resource.email}?" }
        else
          link_to "Resend Password Instructions", generate_password_admin_customer_user_path(resource),
                  method: :post, class: "button",
                  data: { confirm: "Resend password generation email to #{resource.email}?" }
        end
      end
    end
  end

  # Form
  form do |f|
    f.semantic_errors(*f.object.errors.attribute_names)

    f.inputs "User Information" do
      f.input :name, required: true
      f.input :surname, required: true
      f.input :email, required: true, hint: "Used for login and password generation"
      f.input :phone_number, hint: "Optional contact number"
    end

    f.inputs "Customer Assignment" do
      f.input :customer, as: :select,
              collection: Customer.order(:name).collect { |c| [ c.name, c.id ] },
              required: true,
              hint: "Select the customer this user belongs to"
    end

    f.inputs "Access Control" do
      f.input :blocked, hint: "Blocked users cannot log in"
    end

    f.actions
  end

  # Custom member actions
  member_action :generate_password, method: :post do
    if resource.send_password_generation_instructions
      flash[:notice] = "Password generation email sent to #{resource.email}"
    else
      flash[:error] = "Failed to send password generation email"
    end
    redirect_to admin_customer_user_path(resource)
  end

  # Controller customizations
  controller do
    def create
      # Use the custom method that doesn't require a password
      @customer_user = CustomerUser.create_without_password(permitted_params[:customer_user])

      if @customer_user.persisted?
        # Send password generation email after creation
        @customer_user.send_password_generation_instructions
        flash[:notice] = "Customer User created successfully. Password generation email sent to #{@customer_user.email}."
        redirect_to admin_customer_user_path(@customer_user)
      else
        flash.now[:error] = "Failed to create Customer User."
        render :new
      end
    end

    def update
      # Don't allow updating password through admin interface
      if params[:customer_user]
        params[:customer_user].delete("encrypted_password")
        params[:customer_user].delete(:encrypted_password)
      end
      super
    end
  end
end
