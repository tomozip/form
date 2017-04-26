# frozen_string_literal: true

class QuestionAnswer < ApplicationRecord
  belongs_to :user
  belongs_to :question
  has_one :answer_text, dependent: :destroy
  has_many :answer_choices, dependent: :delete_all

  validates :question_id, presence: true
  validates :user_id, presence: true
  validates :user_id, uniqueness: { scope: [:question_id] }

  def self.prepare_que_answer_result(question, answered_user_ids)
    question_answer_ids = question.question_answers.where(user_id: answered_user_ids).pluck(:id)
    if question.category == 'input' || question.category == 'textarea'
      AnswerText.where(question_answer_id: question_answer_ids).pluck(:body)
    else
      question.question_choices.each_with_object({}) do |question_choice, hash|
        hash[question_choice.body] = question_choice.answer_choices.where(
          question_answer_id: question_answer_ids
        ).count
      end
    end
  end

  def self.prepare_answers(question_answers)
    question_answers.each_with_object({}) do |question_answer, answers|
      question_id = question_answer.question_id
      category = question_answer.question.category
      case category
      when 'input', 'textarea'
        body = question_answer.answer_text.body
        answers[question_id.to_s] = { category: category, body: body }
      when 'selectbox', 'radio'
        question_choice_id = question_answer.answer_choices.first.question_choice_id
        answers[question_id.to_s] = { category: category, question_choice_id: question_choice_id }
      when 'checkbox'
        question_choice_ids = question_answer.answer_choices.pluck(:question_choice_id)
        answers[question_id.to_s] = { category: category, question_choice_ids: question_choice_ids }
      end
    end
  end

  def self.create_with_childs(key, que_answer, user_id)
    question_answer_id = QuestionAnswer.create!(question_id: key.to_i, user_id: user_id).id
    case que_answer[:category]
    when 'input', 'textarea'
      AnswerText.create_by_params(que_answer, question_answer_id)
    when 'selectbox', 'radio'
      AnswerChoice.create_by_params(que_answer, question_answer_id)
    when 'checkbox'
      raise 'No checked choice' if que_answer.length < 2
      que_answer.each do |index, choice|
        next if index == 'category'
        AnswerChoice.create_by_params(choice, question_answer_id)
      end
    end
  end


  def self.tem_create_with_childs(key, que_answer, user_id)
    # 一時保存の場合はview側のjsで空白を弾かないためcontroller側で内容がnilじゃないか毎回確かめる。
    value_is_null = checkbox_is_null(que_answer) && que_answer[:body].blank? && que_answer[:question_choice_id].blank?
    value_is_null || create_with_childs(key, que_answer, user_id)
  end

  def self.update_with_childs(que_answer, question_answer_id)
    case que_answer[:category]
    when 'input', 'textarea'
      raise 'que_answer is nil' if que_answer[:body].blank?
      AnswerText.find_by(question_answer_id: question_answer_id)
                .update(que_answer.permit(:body))
    when 'selectbox', 'radio'
      raise 'que_answer is nil' if que_answer[:question_choice_id].blank?
      AnswerChoice.find_by(question_answer_id: question_answer_id)
                  .destroy
      AnswerChoice.create_by_params(que_answer, question_answer_id)
    when 'checkbox'
      raise 'que_answer is nil' if que_answer.length < 2
      AnswerChoice.where(question_answer_id: question_answer_id)
                  .delete_all
      que_answer.each do |index, choice|
        next if index == 'category'
        AnswerChoice.create_by_params(choice, question_answer_id)
      end
    end
  end

  def self.tem_update_with_childs(que_answer, question_answer)
    value_is_null = checkbox_is_null(que_answer) && que_answer[:body].blank? && que_answer[:question_choice_id].blank?
    value_is_null ? question_answer.destroy : update_with_childs(que_answer, question_answer.id)
  end

  def self.checkbox_is_null(que_answer)
    (0..9).to_a.none? { |index| que_answer.key?(index.to_s) }
  end
end
