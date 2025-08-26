require 'rails_helper'

RSpec.describe AdminAuthorizationAdapter do
  describe "AdminUser authorization" do
    let(:regular_admin) { create(:admin_user) }
    let(:super_admin) { create(:admin_user, :super_admin) }

    describe "read access" do
      it "allows read access for any admin" do
        adapter = AdminAuthorizationAdapter.new(nil, regular_admin)
        expect(adapter.authorized?(:read, AdminUser)).to be true
        expect(adapter.authorized?(:read, regular_admin)).to be true
      end

      it "allows read access for super admin" do
        adapter = AdminAuthorizationAdapter.new(nil, super_admin)
        expect(adapter.authorized?(:read, AdminUser)).to be true
        expect(adapter.authorized?(:read, super_admin)).to be true
      end
    end

    describe "create access" do
      it "denies create access for regular admin" do
        adapter = AdminAuthorizationAdapter.new(nil, regular_admin)
        expect(adapter.authorized?(:create, AdminUser)).to be false
        expect(adapter.authorized?(:create, regular_admin)).to be false
      end

      it "allows create access for super admin" do
        adapter = AdminAuthorizationAdapter.new(nil, super_admin)
        expect(adapter.authorized?(:create, AdminUser)).to be true
        expect(adapter.authorized?(:create, super_admin)).to be true
      end
    end

    describe "destroy access" do
      it "denies destroy access for regular admin" do
        adapter = AdminAuthorizationAdapter.new(nil, regular_admin)
        expect(adapter.authorized?(:destroy, AdminUser)).to be false
        expect(adapter.authorized?(:destroy, regular_admin)).to be false
      end

      it "allows destroy access for super admin" do
        adapter = AdminAuthorizationAdapter.new(nil, super_admin)
        expect(adapter.authorized?(:destroy, AdminUser)).to be true
        expect(adapter.authorized?(:destroy, super_admin)).to be true
      end
    end

    describe "update access" do
      it "allows update access for super admin on any user" do
        adapter = AdminAuthorizationAdapter.new(nil, super_admin)
        expect(adapter.authorized?(:update, AdminUser)).to be true
        expect(adapter.authorized?(:update, regular_admin)).to be true
        expect(adapter.authorized?(:update, super_admin)).to be true
      end

      it "allows update access for regular admin on themselves" do
        adapter = AdminAuthorizationAdapter.new(nil, regular_admin)
        expect(adapter.authorized?(:update, regular_admin)).to be true
      end

      it "denies update access for regular admin on other users" do
        adapter = AdminAuthorizationAdapter.new(nil, regular_admin)
        expect(adapter.authorized?(:update, super_admin)).to be false
        expect(adapter.authorized?(:update, AdminUser)).to be false
      end
    end

    describe "custom actions" do
      it "denies custom actions for regular admin" do
        adapter = AdminAuthorizationAdapter.new(nil, regular_admin)
        expect(adapter.authorized?(:custom_action, AdminUser)).to be false
        expect(adapter.authorized?(:some_other_action, regular_admin)).to be false
      end

      it "allows custom actions for super admin" do
        adapter = AdminAuthorizationAdapter.new(nil, super_admin)
        expect(adapter.authorized?(:custom_action, AdminUser)).to be true
        expect(adapter.authorized?(:some_other_action, regular_admin)).to be true
      end
    end
  end

  describe "non-AdminUser authorization" do
    let(:regular_admin) { create(:admin_user) }
    let(:super_admin) { create(:admin_user, :super_admin) }

    it "allows all actions for regular admin" do
      adapter = AdminAuthorizationAdapter.new(nil, regular_admin)

      expect(adapter.authorized?(:read, "SomeOtherResource")).to be true
      expect(adapter.authorized?(:create, "SomeOtherResource")).to be true
      expect(adapter.authorized?(:update, "SomeOtherResource")).to be true
      expect(adapter.authorized?(:destroy, "SomeOtherResource")).to be true
      expect(adapter.authorized?(:custom_action, "SomeOtherResource")).to be true
    end

    it "allows all actions for super admin" do
      adapter = AdminAuthorizationAdapter.new(nil, super_admin)

      expect(adapter.authorized?(:read, "SomeOtherResource")).to be true
      expect(adapter.authorized?(:create, "SomeOtherResource")).to be true
      expect(adapter.authorized?(:update, "SomeOtherResource")).to be true
      expect(adapter.authorized?(:destroy, "SomeOtherResource")).to be true
      expect(adapter.authorized?(:custom_action, "SomeOtherResource")).to be true
    end
  end

  describe "nil user handling" do
    let(:adapter) { AdminAuthorizationAdapter.new(nil, nil) }

    it "denies AdminUser actions when user is nil" do
      expect(adapter.authorized?(:create, AdminUser)).to be_falsey
      expect(adapter.authorized?(:destroy, AdminUser)).to be_falsey
      expect(adapter.authorized?(:update, AdminUser)).to be_falsey
      expect(adapter.authorized?(:custom_action, AdminUser)).to be_falsey
    end

    it "allows read access when user is nil" do
      expect(adapter.authorized?(:read, AdminUser)).to be true
    end

    it "allows non-AdminUser subjects when user is nil" do
      expect(adapter.authorized?(:read, "SomeOtherResource")).to be true
    end
  end

  describe "edge cases" do
    let(:regular_admin) { create(:admin_user) }
    let(:adapter) { AdminAuthorizationAdapter.new(nil, regular_admin) }

    it "handles nil subject gracefully" do
      expect(adapter.authorized?(:read, nil)).to be true
      expect(adapter.authorized?(:create, nil)).to be true
    end

    it "handles empty subject gracefully" do
      expect(adapter.authorized?(:read, "")).to be true
      expect(adapter.authorized?(:create, "")).to be true
    end
  end
end
