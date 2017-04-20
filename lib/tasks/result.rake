namespace :result do
  desc "アンケートidを入力で質問ごとの回答者数を表示"
  task :show, ['questionnaire_id'] => :environment do |task, args|
    questions = Question.where(questionnaire_id: args.questionnaire_id)
    results = {}
    answered_user_ids = Answer.where(questionnaire_id: args.questionnaire_id, status: 'answered').pluck(:user_id)
    questions.each do |question|
      question_answers = QuestionAnswer.where(question_id: question.id, user_id: answered_user_ids)
      if question.category == 'input' || question.category == 'textarea'

        results[question.body] = { "回答数" => question_answers.count }
      else
        choice_results = {}
        choices = QuestionChoice.where(question_id: question.id)
        choices.each do |choice|
          num_choice_answer = AnswerChoice.where(question_choice_id: choice.id, question_answer_id: question_answers.pluck(:id)).count
          choice_results[choice.body] = num_choice_answer
        end
        results[question.body] = choice_results
      end
    end
    p results
  end
end
