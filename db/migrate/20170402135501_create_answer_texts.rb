class CreateAnswerTexts < ActiveRecord::Migration[5.0]
  def change
    create_table :answer_texts do |t|
      t.references :question_answer, foreign_key: true
      t.string :body

      t.timestamps
    end
  end
end
