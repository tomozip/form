class QuestionnairesController < ApplicationController

  def index
    @questionnaires = Questionnaire.all
    @questionnaire = Questionnaire.new
  end

  def create
    @questionnaire = Questionnaire.new(questionnaire_params)
    if @questionnaire.save
      redirect_to questionnaire_path(@questionnaire.id)
      flash[:done] = '新規アンケートを作成しました。質問を追加して、[確定]ボタンで送信してください。'
    else
      @questionnaires = Questionnaire.all
      render 'index'
    end
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
    if questionnaire.save
      flash[:done] = 'アンケートを発行しました。'
      redirect_to questionnaires_path
    else
      @questionnaire = Questionnaire.find(params[:id])
      render 'show'
    end
  end

  def questionnaire_list
    answers = Answer.where(user_id: params[:user_id])
    if answers.empty?
      @questionnaires = nil
      render 'answers/questionnaire_list'
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
      questionnaires = Questionnaire.where(status: 'sent')
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
    render 'answers/questionnaire_list'
  end

  private
    def questionnaire_params
      params.require(:questionnaire).permit(:title, :description)
    end

end
