# frozen_string_literal: true

class QuestionAnswer < ApplicationRecord
  belongs_to :user
  belongs_to :question
  has_many :answer_texts, dependent: :delete_all
  has_many :answer_choices, dependent: :delete_all

  def self.prepare_answers(question_answers)
    answers = {}
    question_answers.each do |question_answer|
      question_id = question_answer.question_id
      category = Question.find(question_id)[:category]
      case category
      when 'input', 'textarea'
        body = AnswerText.find_by(question_answer_id: question_answer.id).body
        answers[question_id.to_s] = { category: category, body: body }
      when 'selectbox', 'radio'
        question_choice_id = AnswerChoice.find_by(question_answer_id: question_answer.id).question_choice_id
        answers[question_id.to_s] = { category: category, question_choice_id: question_choice_id }
      when 'checkbox'
        temporary_ids = AnswerChoice.where(question_answer_id: question_answer.id)
                                    .pluck(:question_choice_id)
        question_choice_ids = []
        temporary_ids.each do |value|
          question_choice_ids.push(value)
        end
        answers[question_id.to_s] = { category: category, question_choice_ids: question_choice_ids }
      end
    end
    answers
  end

  def self.create_with_childs(key, que_answer, user_id)
    question_answer_id = QuestionAnswer.create(question_id: key.to_i, user_id: user_id).id
    case que_answer[:category]
    when 'input', 'textarea'
      AnswerText.create_by_params(que_answer, question_answer_id)
    when 'selectbox', 'radio'
      AnswerChoice.create_by_params(que_answer, question_answer_id)
    when 'checkbox'
      que_answer.each do |index, choice|
        next if index == 'category'
        AnswerChoice.create_by_params(choice, question_answer_id)
      end
    end
  end

  def self.tem_create_with_childs(key, que_answer, user_id)
    # 一時保存の場合はview側のjsで空白を弾かないためcontroller側で内容がnilじゃないか毎回確かめる。
    value_isNull = checkbox_isNull(que_answer) && que_answer[:body].blank? && que_answer[:question_choice_id].blank?
    value_isNull || create_with_childs(key, que_answer, user_id)
  end

  def self.update_with_childs(que_answer, question_answer_id)
    case que_answer[:category]
    when 'input', 'textarea'
      AnswerText.find_by(question_answer_id: question_answer_id)
                .update(que_answer.permit(:body))
    when 'selectbox', 'radio'
      AnswerChoice.find_by(question_answer_id: question_answer_id)
                  .destroy
      AnswerChoice.create_by_params(que_answer, question_answer_id)
    when 'checkbox'
      AnswerChoice.where(question_answer_id: question_answer_id)
                  .delete_all
      que_answer.each do |index, choice|
        next if index == 'category'
        AnswerChoice.create_by_params(choice, question_answer_id)
      end
    end
  end

  def self.tem_update_with_childs(que_answer, question_answer)
    value_isNull = checkbox_isNull(que_answer) && que_answer[:body].blank? && que_answer[:question_choice_id].blank?
    value_isNull ? question_answer.destroy : update_with_childs(que_answer, question_answer.id)
  end

  def self.checkbox_isNull(que_answer)
    checkbox_isNull = true
    10.times do |index|
      checkbox_isNull = false if que_answer.key?(index.to_s)
    end
    checkbox_isNull
  end
end
