# frozen_string_literal: true

class CompaniesUser < ApplicationRecord
  belongs_to :company
  belongs_to :user
  enum manager: { general: 0, delegate: 1 }

  validates :user_id, presence: true
  validates :company_id, presence: true
  validates :manager, presence: true
  validates :manager, inclusion: { in: CompaniesUser.managers.keys }
  validates :manager, uniqueness: { scope: [:company_id] }, if: :appoint_delegate?

  def self.prepare_member_results(user_id, questionnaire_id)
    user = User.find(user_id)
    member_ids = CompaniesUser.where(company: user.companies_user.company).pluck(:user_id)
    answered_member_ids = Answer.where(
      user_id: member_ids,
      questionnaire_id: questionnaire_id,
      status: 'answered'
    ).pluck(:user_id)
    questionnaire = Questionnaire.find(questionnaire_id)
    Answer.prepare_answer_result(questionnaire.questions, answered_member_ids)
  end

  def self.set_manager(company_id)
  CompaniesUser.find_by(company_id: company_id, manager: 'delegate').try(:user)
  end

  def appoint_delegate?
    manager == 'delegate'
  end
end
