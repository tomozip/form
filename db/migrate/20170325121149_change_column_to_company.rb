class ChangeColumnToCompany < ActiveRecord::Migration[5.0]
  def change
    rename_column :companies, :password, :password_digest
  end
end
