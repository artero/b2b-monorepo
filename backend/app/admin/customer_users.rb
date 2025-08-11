ActiveAdmin.register CustomerUser do
  # Specify parameters which should be permitted for assignment
  permit_params :email, :encrypted_password, :reset_password_token, :reset_password_sent_at, :remember_created_at, :name, :surname, :phone_number, :customer_id, :blocked

  # or consider:
  #
  # permit_params do
  #   permitted = [:email, :encrypted_password, :reset_password_token, :reset_password_sent_at, :remember_created_at, :name, :surname, :phone_number, :customer_id, :blocked]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  # For security, limit the actions that should be available
  actions :all, except: []

  # Add or remove filters to toggle their visibility
  filter :id
  filter :email
  filter :encrypted_password
  filter :reset_password_token
  filter :reset_password_sent_at
  filter :remember_created_at
  filter :name
  filter :surname
  filter :phone_number
  filter :customer
  filter :blocked
  filter :created_at
  filter :updated_at

  # Add or remove columns to toggle their visibility in the index action
  index do
    selectable_column
    id_column
    column :email
    column :encrypted_password
    column :reset_password_token
    column :reset_password_sent_at
    column :remember_created_at
    column :name
    column :surname
    column :phone_number
    column :customer
    column :blocked
    column :created_at
    column :updated_at
    actions
  end

  # Add or remove rows to toggle their visibility in the show action
  show do
    attributes_table_for(resource) do
      row :id
      row :email
      row :encrypted_password
      row :reset_password_token
      row :reset_password_sent_at
      row :remember_created_at
      row :name
      row :surname
      row :phone_number
      row :customer
      row :blocked
      row :created_at
      row :updated_at
    end
  end

  # Add or remove fields to toggle their visibility in the form
  form do |f|
    f.semantic_errors(*f.object.errors.attribute_names)
    f.inputs do
      f.input :email
      f.input :encrypted_password
      f.input :reset_password_token
      f.input :reset_password_sent_at
      f.input :remember_created_at
      f.input :name
      f.input :surname
      f.input :phone_number
      f.input :customer
      f.input :blocked
    end
    f.actions
  end
end
