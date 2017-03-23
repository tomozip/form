class CreateCompaniesUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :companies_users do |t|
      t.references :company, foreign_key: true
      t.references :user, foreign_key: true
      t.integer :manager, default: 0, null: false

      t.timestamps
    end
  end
end
