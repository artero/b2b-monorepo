ActiveAdmin.register User do
  permit_params :name, :surname, :phone_number, :email, :business_partner_id, :blocked

  # Menu configuration
  menu priority: 3, label: "Users"

  # Scopes for filtering
  scope :all, default: true
  scope :active, -> { User.active }
  scope :blocked, -> { User.blocked }

  # Filters
  filter :business_partner, as: :select, collection: -> { BusinessPartner.order(:name) }
  filter :name
  filter :surname
  filter :email
  filter :phone_number
  filter :blocked
  filter :created_at
  filter :updated_at

  # Index page
  index title: "Users" do
    selectable_column
    column :name do |user|
      link_to user.full_name, admin_user_path(user)
    end
    column :email
    column :business_partner do |user|
      link_to user.business_partner.name, admin_business_partner_path(user.business_partner)
    end
      column :blocked
    column :created_at, sortable: :created_at do |user|
      l(user.created_at, format: :short)
    end
    actions do |user|
      unless user.encrypted_password.present?
        item "Generate Password", generate_password_admin_user_path(user),
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
      row :business_partner do |user|
        link_to user.business_partner.name, admin_business_partner_path(user.business_partner)
      end
      row :blocked
      # row "Password Status" do |user|
      #  if user.generated_password_at.present?
      #    status_tag "Password Set", "ok"
      #  else
      #    status_tag "Password Pending", "warning"
      #  end
      # end
      row :reset_password_sent_at do |user|
        user.reset_password_sent_at&.strftime("%B %d, %Y at %I:%M %p")
      end
      row :created_at
      row :updated_at
      row :generated_password_at
    end

    panel "Actions" do
      div do
        unless resource.encrypted_password.present?
          link_to "Generate Password", generate_password_admin_user_path(resource),
                  method: :post, class: "button",
                  data: { confirm: "Send password generation email to #{resource.email}?" }
        else
          link_to "Resend Password Instructions", generate_password_admin_user_path(resource),
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

    f.inputs "Business Partner Assignment" do
      f.input :business_partner, as: :select,
              collection: BusinessPartner.order(:name).collect { |c| [ c.name, c.id ] },
              required: true,
              hint: "Select the business partner this user belongs to"
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
    redirect_to admin_user_path(resource)
  end

  # Controller customizations
  controller do
    def create
      # Use the custom method that doesn't require a password
      @user = User.create_without_password(permitted_params[:user])

      if @user.persisted?
        # Send password generation email after creation
        @user.send_password_generation_instructions
        flash[:notice] = "User created successfully. Password generation email sent to #{@user.email}."
        redirect_to admin_user_path(@user)
      else
        flash.now[:error] = "Failed to create User."
        render :new
      end
    end

    def update
      # Don't allow updating password through admin interface
      if params[:user]
        params[:user].delete("encrypted_password")
        params[:user].delete(:encrypted_password)
      end
      super
    end
  end
end
