class AdminAuthorizationAdapter < ActiveAdmin::AuthorizationAdapter
  def authorized?(action, subject = nil)
    case subject
    when normalized(AdminUser)
      case action
      when :read
        true
      when :create, :destroy
        user&.super_admin?
      when :update
        user&.super_admin? || (subject && user == subject)
      else
        user&.super_admin?
      end
    else
      true
    end
  end
end
