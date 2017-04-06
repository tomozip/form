class AnswersController < ApplicationController

  def new
    form_set
    @answer = Answer.new
  end

  def create
    if params[:temporary]
      answer_create('answering')
      create_temporary_question
    else
      answer_create('answered')
      create_question
    end
    redirect_to questionnaire_list_user_questionnaires_path(params[:user_id])
  end

  def edit
    form_set
    @answer = Answer.find_by(user_id: params[:user_id], questionnaire_id: params[:questionnaire_id])
    @answers = {}
    @answered_question_ids = []
    question_ids = Question.where(questionnaire_id: params[:questionnaire_id])
    question_answers = QuestionAnswer.where(question_id: question_ids, user_id: params[:user_id])
    question_answers.each do |question_answer|
      question_id = question_answer.question_id
      @answered_question_ids.push(question_id)
      category = Question.find(question_id)[:category]
      case category
      when 'input', 'textarea'
        body = AnswerText.find_by(question_answer_id: question_answer.id).body
        @answers[question_id.to_s] = {category: category, body: body}
      when 'selectbox', 'radio'
        question_choice_id = AnswerChoice.find_by(question_answer_id: question_answer.id).question_choice_id
        @answers[question_id.to_s] = {category: category, question_choice_id: question_choice_id}
      when 'checkbox'
        temporary_ids = AnswerChoice.where(question_answer_id: question_answer.id).select(:question_choice_id)
        question_choice_ids = []
        temporary_ids.each do |value|
          question_choice_ids.push(value.question_choice_id)
        end
        @answers[question_id.to_s] = {category: category, question_choice_ids: question_choice_ids}
      end
    end
    # @answers.empty? => true
  end

  def update

  end

  def show

  end

  def destroy
  end

  private
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

    def answer_create(status)
      Answer.create(
        user_id: params[:user_id],
        questionnaire_id: params[:questionnaire_id],
        status: status
      )
    end

    def create_question
      params.require(:answer).each do |key, value|
        question_answer_id = create_question_answer(key.to_i)
        category =  params.require(:answer).require(key.to_sym).require(:category)
        case category
        when 'input', 'textarea'
          answer_text_params = params.require(:answer).require(key.to_sym).permit(:body)
          answer_text_params[:question_answer_id] = question_answer_id
          AnswerText.create(answer_text_params)
        when 'selectbox', 'radio'
          answer_choice_params = params.require(:answer).require(key.to_sym).permit(:question_choice_id)
          answer_choice_params[:question_answer_id] = question_answer_id
          AnswerChoice.create(answer_choice_params)
        when 'checkbox'
          params.require(:answer).require(key.to_sym).each do |key2, value2|
            next if key2 == 'category'
            answer_choice_params = params.require(:answer).require(key.to_sym).require(key2.to_sym).permit(:question_choice_id)
            answer_choice_params[:question_answer_id] = question_answer_id
            AnswerChoice.create(answer_choice_params)
          end
        end
      end
    end

    def create_temporary_question
      params.require(:answer).each do |key, value|
        category = params.require(:answer).require(key.to_sym).require(:category)
        case category
        when 'input', 'textarea'
          value_isNull = params.require(:answer).require(key.to_sym)[:body].empty?
          unless value_isNull
            question_answer_id = create_question_answer(key.to_i)
            answer_text_params = params.require(:answer).require(key.to_sym).permit(:body)
            answer_text_params[:question_answer_id] = question_answer_id
            AnswerText.create(answer_text_params)
          end
        when 'selectbox', 'radio'
          value_isNull = params.require(:answer).require(key.to_sym)[:question_choice_id].blank?
          unless value_isNull
            question_answer_id = create_question_answer(key.to_i)
            answer_choice_params = params.require(:answer).require(key.to_sym).permit(:question_choice_id)
            answer_choice_params[:question_answer_id] = question_answer_id
            AnswerChoice.create(answer_choice_params)
          end
        when 'checkbox'
          value_isNull = params.require(:answer).require(key.to_sym).length <= 1
          unless value_isNull
            question_answer_id = create_question_answer(key.to_i)
            params.require(:answer).require(key.to_sym).each do |key2, value2|
              next if key2 == 'category'
              answer_choice_params = params.require(:answer).require(key.to_sym).require(key2.to_sym).permit(:question_choice_id)
              answer_choice_params[:question_answer_id] = question_answer_id
              AnswerChoice.create(answer_choice_params)
            end
          end
        end
      end
    end

    def update_temporary_question
      params.require(:answer).each do |key, value|
        category = params.require(:answer).require(key.to_sym).require(:category)
        case category
        when 'input', 'textarea'
          value_isNull = params.require(:answer).require(key.to_sym)[:body].empty?
          if value_isNull
            question_answer = QuestionAnswer.find_by(user_id: params[:user_id], question_id: key.to_i)
            question_answer.destroy
          else
            question_answer_id = create_question_answer(key.to_i)
            answer_text_params = params.require(:answer).require(key.to_sym).permit(:body)
            answer_text_params[:question_answer_id] = question_answer_id
            AnswerText.create(answer_text_params)
          end
        when 'selectbox', 'radio'
          value_isNull = params.require(:answer).require(key.to_sym)[:question_choice_id].blank?
          if value_isNull
            question_answer = QuestionAnswer.find_by(user_id: params[:user_id], question_id: key.to_i)
            question_answer.destroy
          else
            question_answer_id = create_question_answer(key.to_i)
            answer_choice_params = params.require(:answer).require(key.to_sym).permit(:question_choice_id)
            answer_choice_params[:question_answer_id] = question_answer_id
            AnswerChoice.create(answer_choice_params)
          end
        when 'checkbox'
          value_isNull = params.require(:answer).require(key.to_sym)[:question_choice_id].blank?
          if value_isNull
          else
            params.require(:answer).require(key.to_sym).each do |key2, value2|
              next if key2 == 'category'
              question_answer_id = create_question_answer(key.to_i)
              answer_choice_params = params.require(:answer).require(key.to_sym).require(key2.to_sym).permit(:question_choice_id)
              answer_choice_params[:question_answer_id] = question_answer_id
              AnswerChoice.create(answer_choice_params)
            end
          end
        end
      end
    end

    def create_question_answer(question_id)
      question_answer = QuestionAnswer.create(question_id: question_id, user_id: current_user.id)
      question_answer.id
    end
end
