class ChangeColumnToCompanies < ActiveRecord::Migration[5.0]
  def change
    change_column :companies, :url, :string, null: false
    rename_column :companies, :url, :password
  end
end
