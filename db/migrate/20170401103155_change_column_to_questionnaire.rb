class ChangeColumnToQuestionnaire < ActiveRecord::Migration[5.0]
  def change

change_column :questionnaires, :status, :integer, default: 0
  end
end
