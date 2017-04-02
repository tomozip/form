class AnswersController < ApplicationController

  def new
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
    @answer = Answer.new
  end

  def create
    Answer.create(
      user_id: params[:user_id],
      questionnaire_id: params[:questionnaire_id],
      status: 'answered'
    )
    create_question
  end

  def show

  end

  def update

  end

  def destroy
  end

  private
    def create_question
      params.require(:answer).each do |key, value|
        category = params.require(:answer).require(key.to_sym).require(:category)
        case category
        when 'input'
        when 'textarea'
          answer_text_params = params.require(:answer).require(key.to_sym).permit(:body)
          AnswerText.create(answer_text_params)
        when 'selectbox'
        when 'radio'
          answer_choice_params = params.require(:answer).require(key.to_sym).permit(:question_choice_id)
          AnswerChoice.create(answer_choice_params)
        when 'checkbox'
          params.require(:answer).require(key.to_sym).each do |key2, value2|
            answer_choice_params = params.require(:answer).require(key.to_sym).require(key2.to_sym).permit(:question_choice_id)
            AnswerChoice.create(answer_choice_params)
          end
        end
      end
    end
end
