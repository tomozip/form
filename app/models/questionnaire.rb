# frozen_string_literal: true

class Questionnaire < ApplicationRecord
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :delete_all
  enum status: { 'editing' => 0, 'sent' => 1 }

  validates :title, presence: true
  validates :description, presence: true
  validates :status, presence: true
  validates :status, inclusion: { in: Questionnaire.statuses.keys }

  def self.prepare_questionnaire_list(answering_questionnaire_ids, answered_questionnaire_ids)
    questionnaires = Questionnaire.where(status: 'sent')
    questionnaires.each_with_object({}) do |questionnaire, list|
      if answered_questionnaire_ids.include?(questionnaire.id)
        list[:answered].try(:push, questionnaire.id) || list[:answered] = [questionnaire]
      elsif answering_questionnaire_ids.include?(questionnaire.id)
        list[:answering].try(:push, questionnaire) || list[:answering] = [questionnaire]
      else
        list[:not_yet].try(:push, questionnaire) || list[:not_yet] = [questionnaire]
      end
    end
  end
end
