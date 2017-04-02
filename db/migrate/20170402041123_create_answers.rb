class CreateAnswers < ActiveRecord::Migration[5.0]
  def change
    create_table :answers do |t|
      t.references :user, foreign_key: true
      t.references :questionnaire, foreign_key: true
      t.integer :status

      t.timestamps
    end
  end
end
