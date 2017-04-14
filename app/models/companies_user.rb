# frozen_string_literal: true

class CompaniesUser < ApplicationRecord
  belongs_to :company
  belongs_to :user
  enum manager: { general: 0, delegate: 1 }

  def self.prepare_member_resules(questions, user_id, questionnaire_id)
    company_id = CompaniesUser.find_by(user_id: user_id).company_id
    member_ids = CompaniesUser.where(company_id: company_id).pluck(:user_id)
    answered_member_ids = Answer.where(
      questionnaire_id: questionnaire_id,
      status: 'answered',
      user_id: member_ids
    ).pluck(:user_id)
    Answer.prepare_answer_result(questions, answered_member_ids)
  end

  def self.set_manager(company_id)
    manager_id = CompaniesUser.find_by(company_id: company_id, manager: 'delegate').user_id
    User.find(manager_id)
  end
end
