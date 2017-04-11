class CreateQuestionChoices < ActiveRecord::Migration[5.0]
  def change
    create_table :question_choices do |t|
      t.references :question, foreign_key: true
      t.string :body

      t.timestamps
    end
  end
end
