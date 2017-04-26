# frozen_string_literal: true

class QuestionnairesController < ApplicationController
  before_action :block_admin, only: [:questionnaire_list]
  before_action :authenticate_user!, only: [:questionnaire_list]
  before_action :block_user, except: [:questionnaire_list]
  before_action :authenticate_admin!, except: [:questionnaire_list]

  def index
    @questionnaire = Questionnaire.new
  end

  def create
    @questionnaire = Questionnaire.new(questionnaire_params)
    if @questionnaire.save
      redirect_to questionnaire_path(@questionnaire.id), notice: '新規アンケートを作成しました。質問を追加して、[発行]ボタンで送信してください。'
    else
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
    questionnaire_ids = answers.each_with_object({}) do |answer, hash|
      questionnaire_id = answer.questionnaire_id
      if answer.status == 'answering'
        hash[:answering].try(:push, questionnaire_id) || hash[:answering] = [questionnaire_id]
      else
        hash[:answered].try(:push, questionnaire_id) || hash[:answered] = [questionnaire_id]
      end
    end
    @questionnaires = Questionnaire.prepare_questionnaire_list(
      questionnaire_ids[:answering],
      questionnaire_ids[:answered]
    )
    render 'answers/questionnaire_list'
  end

  def result
    @questionnaire = Questionnaire.find(params[:id])
    answered_user_ids = Answer.where(questionnaire_id: params[:id], status: 'answered')
                              .pluck(:user_id)
    @results = Answer.prepare_answer_result(@questionnaire.questions, answered_user_ids)
    render 'result'
  end

  private

  def questionnaire_params
    params.require(:questionnaire).permit(:title, :description)
  end

  def block_admin
    return unless admin_signed_in?
    warning = '現在管理者としてログイン中です。一度ログアウトしてからユーザーログインしてください。'
    redirect_to admin_path(current_admin.id), alert: warning
  end

  def block_user
    return unless user_signed_in?
    warning = 'ユーザーとしてログイン中です。一度ログアウトしてから管理者ログインしてください。'
    redirect_to user_path(current_user.id), alert: warning
  end
end
