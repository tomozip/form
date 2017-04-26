# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :block_admin
  before_action :authenticate_user!

  def new
    form_set
    @answer = Answer.new
  end

  def create
    if params[:temporary]
      Answer.tem_create_with_que_answer(create_params)
    else
      Answer.create_with_que_answer(create_params)
    end
    redirect_to questionnaire_list_user_questionnaires_path(params[:user_id])
    # flash.now(msg)
  end

  def update
    if params[:temporary]
      Answer.tem_update_with_que_answer(create_params)
    else
      Answer.update_with_que_answer(create_params)
    end
    redirect_to questionnaire_list_user_questionnaires_path(params[:user_id])
  end

  def edit
    form_set
    @answer = Answer.find_by(user_id: params[:user_id], questionnaire_id: params[:questionnaire_id])
    question_ids = Question.where(questionnaire_id: params[:questionnaire_id])
    question_answers = QuestionAnswer.where(question_id: question_ids, user_id: params[:user_id])
    @answered_question_ids = question_answers.pluck(:question_id)
    @answers = QuestionAnswer.prepare_answers(question_answers)
    # @answers.empty? => true
  end

  def show
    @questionnaire = Questionnaire.find(params[:questionnaire_id])
    @results = CompaniesUser.prepare_member_results(
      @questionnaire.questions,
      params[:user_id],
      params[:questionnaire_id]
    )
    render 'questionnaires/result'
  end

  def destroy; end

  private

  def create_params
    {
      answer: params[:answer],
      user_id: params[:user_id],
      questionnaire_id: params[:questionnaire_id]
    }
  end

  def form_set
    @user = User.find(params[:user_id])
    @questionnaire = Questionnaire.find(params[:questionnaire_id])
    @questions = Question.where(questionnaire_id: @questionnaire.id)
    @options = {}
    @questions.each do |question|
      category = question.category
      if category == 'selectbox' || category == 'checkbox' || category == 'radio'
        question_choices = QuestionChoice.where(question_id: question.id)
        @options.store(question.id, [question_choices])
      end
    end
  end

  def block_admin
    return unless admin_signed_in?
    warning = '現在管理者としてログイン中です。一度ログアウトしてからユーザーログインしてください。'
    redirect_to admin_path(current_admin.id), alert: warning
  end
end
