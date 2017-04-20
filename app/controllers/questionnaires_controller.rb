# frozen_string_literal: true

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
    @questionnaires = Questionnaire.prepare_questionnaire_list(
      answering_questionnaire_ids,
      answered_questionnaire_ids
    )
    render 'answers/questionnaire_list'
  end

  private

  def questionnaire_params
    params.require(:questionnaire).permit(:title, :description)
  end
end
