class QuestionsController < ApplicationController
  def create
    @questionnaire = Questionnaire.find(params[:questionnaire_id])
    @question = @questionnaire.questions.create(question_params)
    # Question.create(question_params)
    redirect_to questionnaire_path(params[:questionnaire_id])
  end

  def destroy
  end

  private
    def question_params
      params.require(:question).permit(:body, :category)
    end

end
