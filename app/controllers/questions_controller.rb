class QuestionsController < ApplicationController
  def create
    @questionnaire = Questionnaire.find(params[:questionnaire_id])
    question = @questionnaire.questions.create(question_params)
    has_choices? && create_choices(question.id)
    redirect_to questionnaire_path(params[:questionnaire_id])
  end

  def destroy
  end

  private
    def question_params
      params.require(:question).permit(:body, :category)
    end

    def has_choices?
      flag = false
      params.each_key do |key|
        flag = true if key == 'question_choice'
      end
      flag
    end

    def create_choices(question_id)
      numChoice = params.require(:question_choice).length
      numChoice.times do |i|
        key = "choice#{i}"
        params.require(:question_choice).require(key.to_sym)['question_id'] = question_id
        choice_params = params.require(:question_choice).require(key.to_sym).permit(:body, :question_id)
        QuestionChoice.create(choice_params)
      end
    end

end
