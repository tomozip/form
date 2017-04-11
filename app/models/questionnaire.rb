# frozen_string_literal: true

class Questionnaire < ApplicationRecord
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :delete_all
  enum status: { 'editing' => 0, 'sent' => 1 }

  def self.prepare_questionnaire_list(answering_questionnaire_ids, answered_questionnaire_ids)
    questionnaires = Questionnaire.where(status: 'sent')
    list = { answered: [], answering: [], not_yet: [] }
    questionnaires.each do |questionnaire|
      questionnaire_id = questionnaire.id
      if answered_questionnaire_ids.include?(questionnaire_id)
        list[:answered].push(questionnaire)
      elsif answering_questionnaire_ids.include?(questionnaire_id)
        list[:answering].push(questionnaire)
      else
        list[:not_yet].push(questionnaire)
      end
    end
    list
  end
end
