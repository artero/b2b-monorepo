ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  content title: proc { I18n.t("active_admin.dashboard") } do
    div class: "px-4 py-16 md:py-32 text-center m-auto max-w-3xl" do
      para "Administrador de B2B WebShop", class: "mt-2 text-3xl sm:text-4xl font-bold text-gray-900 dark:text-gray-200"
    end
  end
end
