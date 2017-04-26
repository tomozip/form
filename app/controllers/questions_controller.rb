# frozen_string_literal: true

class QuestionsController < ApplicationController
  def create
    @questionnaire = Questionnaire.find(params[:questionnaire_id])
    question = @questionnaire.questions.create(question_params)
    is_choice_question? && create_choices(question.id)
    redirect_to questionnaire_path(params[:questionnaire_id])
  end

  def destroy; end

  private

  def question_params
    params.require(:question).permit(:body, :category)
  end

  def is_choice_question?
    params.any? { |key| key == 'question_choice' }
  end

  def create_choices(question_id)
    num_choice = params.require(:question_choice).length
    num_choice.times do |i|
      key = "choice#{i}"
      params[:question_choice][key.to_sym]['question_id'] = question_id
      choice_params = params.require(:question_choice)
                            .require(key.to_sym)
                            .permit(:body, :question_id)
      QuestionChoice.create(choice_params)
    end
  end
end
