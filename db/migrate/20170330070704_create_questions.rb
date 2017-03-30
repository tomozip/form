class CreateQuestions < ActiveRecord::Migration[5.0]
  def change
    create_table :questions do |t|
      t.references :questionnaire, foreign_key: true
      t.string :body
      t.integer :category

      t.timestamps
    end
  end
end
