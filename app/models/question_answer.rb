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
    # TODO:60 40 .prepare_que_answer_result
    question_answer_ids = QuestionAnswer.where(question_id: question.id, user_id: answered_user_ids)
                                        .pluck(:id)
    case question.category
    when 'input', 'textarea'
      AnswerText.where(question_answer_id: question_answer_ids).pluck(:body)
    when 'selectbox', 'radio', 'checkbox'
      question.question_choices.each_with_object({}) do |question_choice, hash|
        hash[question_choice.body] = AnswerChoice.where(
          question_answer_id: question_answer_ids,
          question_choice_id: question_choice.id
        ).count
      end
    end
  end

  def self.prepare_answers(question_answers)
    # TODO:50 30 .prepare_answers
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
    # #DONE:10 .create_with_childs: createできているかどうか
    QuestionAnswer.transaction do
      question_answer_id = QuestionAnswer.create!(question_id: key.to_i, user_id: user_id).id
      case que_answer[:category]
      when 'input', 'textarea'
        AnswerText.create_by_params(que_answer, question_answer_id)
      when 'selectbox', 'radio'
        AnswerChoice.create_by_params(que_answer, question_answer_id)
      when 'checkbox'
        raise 'No checked choice' if que_answer.length < 2
        que_answer.each do |index, choice|
          # #DONE:0 一つも作らない場合には例外を発生させたいんだぼかぁ。
          next if index == 'category'
          AnswerChoice.create_by_params(choice, question_answer_id)
        end
      end
    end
  end

  def self.tem_create_with_childs(key, que_answer, user_id)
    # #DONE:20 0 .tem_create_with_childs
    # 一時保存の場合はview側のjsで空白を弾かないためcontroller側で内容がnilじゃないか毎回確かめる。
    value_is_null = checkbox_is_null(que_answer) && que_answer[:body].blank? && que_answer[:question_choice_id].blank?
    value_is_null || create_with_childs(key, que_answer, user_id)
  end

  def self.update_with_childs(que_answer, question_answer_id)
    # #DOING:30 10 .update_with_childs
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
    # #DOING:40 20 .tem_update_with_childs
    value_is_null = checkbox_is_null(que_answer) && que_answer[:body].blank? && que_answer[:question_choice_id].blank?
    value_is_null ? question_answer.destroy : update_with_childs(que_answer, question_answer.id)
  end

  def self.checkbox_is_null(que_answer)
    (0..9).to_a.none? { |index| que_answer.key?(index.to_s) }
  end
end
