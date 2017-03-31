class QuestionnairesController < ApplicationController

  def index
    @questionnaires = Questionnaire.all
    @questionnaire = Questionnaire.new
  end

  def create
    Questionnaire.create(questionnaire_params)
    binding.pry
    # redirect_to questionnaire_question_path()
  end

  def destroy

  end

  def show

  end

  private
    def questionnaire_params
      params.require(:questionnaire).permit(:title)
    end
end
