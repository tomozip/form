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
    questionnaire = Questionnaire.find(params[:id])
    questionnaire.destroy
    redirect_to questionnaires_path
  end

  def show
    @questionnaire = Questionnaire.find(params[:id])
    # ajax_action if request.xhr?
  end

  def ajax_form
    @question_info = {
      category: params[:category_select],
      num_choice: params[:num_choice]
    }
    @questionnaire = Questionnaire.find(params[:id])
    @question = @questionnaire.questions.build
    render 'show'
  end

  def update_status
    questionnaire = Questionnaire.find(params[:id])
    questionnaire.status = 'sent'
    questionnaire.save
    redirect_to questionnaires_path
  end

  private
    def questionnaire_params
      params.require(:questionnaire).permit(:title, :description)
    end

end
