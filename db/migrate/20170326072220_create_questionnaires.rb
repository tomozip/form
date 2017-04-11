class CreateQuestionnaires < ActiveRecord::Migration[5.0]
  def change
    create_table :questionnaires do |t|
      t.string :title

      t.timestamps
    end
  end
end
