class AddColumnToQuestionnaire < ActiveRecord::Migration[5.0]
  def change
    add_column :questionnaires, :description, :string
    add_column :questionnaires, :status, :integer
  end
end
