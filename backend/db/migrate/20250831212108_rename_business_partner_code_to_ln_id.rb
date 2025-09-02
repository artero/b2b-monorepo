class RenameBusinessPartnerCodeToLnId < ActiveRecord::Migration[8.0]
  def change
    rename_column :business_partners, :code, :ln_id
  end
end
