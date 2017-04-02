class CreateAnswerChoices < ActiveRecord::Migration[5.0]
  def change
    create_table :answer_choices do |t|
      t.references :question_answer, foreign_key: true
      t.references :question_choice, foreign_key: true

      t.timestamps
    end
  end
end
