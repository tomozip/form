# frozen_string_literal: true

class Answer < ApplicationRecord
  belongs_to :user
  belongs_to :questionnaire
  enum status: { 'answering' => 0, 'answered' => 1 }
  validates :user_id, uniqueness: { scope: :questionnaire_id }

  validates :user_id, presence: true
  validates :questionnaire_id, presence: true
  validates :status, presence: true
  validates :status, inclusion: { in: Answer.statuses.keys }
  validates :user_id, uniqueness: { scope: [:questionnaire_id] }

  def self.prepare_answer_result(questions, answered_user_ids)
    questions.each_with_object({}) do |question, results|
      results[question.id.to_s] = QuestionAnswer.prepare_que_answer_result(
        question, answered_user_ids
      )
    end
  end

  def self.create_with_que_answer(params)
    Answer.transaction do
      create!(status: 'answered',
              user_id: params[:user_id], questionnaire_id: params[:questionnaire_id])
      params[:answer].each do |key, que_answer|
        QuestionAnswer.create_with_childs(key, que_answer, params[:user_id])
      end
    end
  end

  def self.tem_create_with_que_answer(params)
    Answer.transaction do
      create!(status: 'answering',
              user_id: params[:user_id], questionnaire_id: params[:questionnaire_id])
      params[:answer].each do |key, que_answer|
        QuestionAnswer.tem_create_with_childs(key, que_answer, params[:user_id])
      end
    end
  end

  def self.update_with_que_answer(params)
    questionnaire = Questionnaire.find(params[:questionnaire_id])
    question_answers = QuestionAnswer.where(question_id: questionnaire.questions.pluck(:id), user_id: params[:user_id])
    Answer.transaction do
      questionnaire.answers.find_by(user_id: params[:user_id]).update!(status: 'answered')
      params[:answer].each do |key, que_answer|
        question_id = key.to_i
        if question_answers.pluck(:question_id).include?(question_id)
          # 回答済みなら
          question_answer_id = question_answers.find_by(question_id: question_id).id
          QuestionAnswer.update_with_childs(que_answer, question_answer_id)
        else
          # 未回答なら
          QuestionAnswer.create_with_childs(key, que_answer, params[:user_id])
        end
      end
    end
  end

  def self.tem_update_with_que_answer(params)
    questionnaire = Questionnaire.find(params[:questionnaire_id])
    question_answers = QuestionAnswer.where(question_id: questionnaire.questions.pluck(:id), user_id: params[:user_id])
    Answer.transaction do
      params[:answer].each do |key, que_answer|
        question_id = key.to_i
        if question_answers.pluck(:question_id).include?(question_id)
          question_answer = question_answers.find_by(question_id: question_id)
          QuestionAnswer.tem_update_with_childs(que_answer, question_answer)
        else
          QuestionAnswer.tem_create_with_childs(key, que_answer, params[:user_id])
        end
      end
    end
  end
end
