class QuestionnairesController < ApplicationController

  def index
    @questionnaires = Questionnaire.all
    @questionnaire = Questionnaire.new
  end

  def create
    questionnaire = Questionnaire.create(questionnaire_params)
    redirect_to questionnaire_path(questionnaire.id)
  end

  def destroy

  end

  def show
    @questionnaire = Questionnaire.find(params[:id])
    # ajax_action if request.xhr?
  end

  def ajax_form
    @question_info = {
      category: params[:category_select],
      numChoice: params[:numChoice]
    }
    @questionnaire = Questionnaire.find(params[:id])
    render 'show'
  end

  private
    def questionnaire_params
      params.require(:questionnaire).permit(:title)
    end
end
