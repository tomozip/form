class AnswersController < ApplicationController
  def index
    answers = Answer.where(user_id: params[:user_id])
    if answers.empty?
      @questionnaires = nil
      render
    else
      answering_questionnaire_ids = []
      answered_questionnaire_ids = []
      answers.each do |answer|
        questionnaire_id = answer.questionnaire_id
        if answer.status == 'answering'
          answering_questionnaire_ids.push(questionnaire_id)
        else
          answered_questionnaire_ids.push(questionnaire_id)
        end
      end
      questionnaires = Questionnaire.all
      @questionnaires = { answered: [], answering: [], not_yet: [] }
      questionnaires.each do |questionnaire|
        questionnaire_id = questionnaire.id
        if answered_questionnaire_ids.include?(questionnaire_id)
          @questionnaires[:answered].push(questionnaire)
        elsif answering_questionnaire_ids.include?(questionnaire_id)
          @questionnaires[:answering].push(questionnaire)
        else
          @questionnaires[:not_yet].push(questionnaire)
        end
      end
    end
  end

  def show
  end

  def create
  end

  def destroy
  end
end
