class AnswersController < ApplicationController

  def new
    form_set
    @answer = Answer.new
  end

  def create
    que_answers = params.require(:answer)
    if params[:temporary] # 一時保存なら
      create_answer('answering')
      que_answers.each_key { |key| create_temporary_que_answer(key) }
    else # 完全送信なら
      create_answer('answered')
      que_answers.each_key { |key| create_que_answer(key) }
    end
    redirect_to questionnaire_list_user_questionnaires_path(params[:user_id])
  end

  def update
    que_answers = params.require(:answer)
    question_ids = Question.where(questionnaire_id: params[:questionnaire_id]).pluck(:id)
    question_answers = QuestionAnswer.where(question_id: question_ids)
    answered_question_ids = question_answers.pluck(:question_id)
    if params[:temporary]
      que_answers.each_key do |key|
        question_id = key.to_i
        if answered_question_ids.include?(question_id)
          update_temporary_que_answer(key, question_id, question_answers)
        else
          create_temporary_que_answer(key)
        end
      end
    else
      update_answer
      que_answers.each_key do |key|
        question_id = key.to_i
        if answered_question_ids.include?(question_id)
          # 回答済みなら
          update_temporary_que_answer(key, question_id, question_answers)
        else
          # 未回答なら
          create_que_answer(key)
        end
      end
    end
    redirect_to questionnaire_list_user_questionnaires_path(params[:user_id])
  end

  def edit
    form_set
    @answer = Answer.find_by(user_id: params[:user_id], questionnaire_id: params[:questionnaire_id])
    @answers = {}
    question_ids = Question.where(questionnaire_id: params[:questionnaire_id])
    question_answers = QuestionAnswer.where(question_id: question_ids, user_id: params[:user_id])
    @answered_question_ids = question_answers.pluck(:question_id)
    question_answers.each do |question_answer|
      question_id = question_answer.question_id
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

    def create_answer(status)
      Answer.create(
        user_id: params[:user_id],
        questionnaire_id: params[:questionnaire_id],
        status: status
      )
    end

    def update_answer
      answer = Answer.find_by(
        user_id: params[:user_id],
        questionnaire_id: params[:questionnaire_id]
      )
      answer.update(status: 'answered')
    end

    def create_que_answer(key)
      que_answer = params.require(:answer).require(key.to_sym)
      question_answer_id = create_simple_que_answer(key.to_i)
      case que_answer[:category]
      when 'input', 'textarea'
        answer_text_params = que_answer.permit(:body)
        answer_text_params[:question_answer_id] = question_answer_id
        AnswerText.create(answer_text_params)
      when 'selectbox', 'radio'
        answer_choice_params = que_answer.permit(:question_choice_id)
        answer_choice_params[:question_answer_id] = question_answer_id
        AnswerChoice.create(answer_choice_params)
      when 'checkbox'
        que_answer.each_key do |index|
          next if index == 'category'
          answer_choice_params = que_answer[index].permit(:question_choice_id)
          answer_choice_params[:question_answer_id] = question_answer_id
          AnswerChoice.create(answer_choice_params)
        end
      end
    end

    def create_temporary_que_answer(key)
      # 一時保存の場合はview側のjsで空白を弾かないためcontroller側で内容がnilじゃないか毎回確かめる。
      que_answer = params.require(:answer).require(key.to_sym)
      question_id = key.to_i
      case que_answer[:category]
      when 'input', 'textarea'
        value_isNull = que_answer[:body].empty?
        unless value_isNull
          question_answer_id = create_simple_que_answer(question_id)
          answer_text_params = que_answer.permit(:body)
          answer_text_params[:question_answer_id] = question_answer_id
          AnswerText.create(answer_text_params)
        end
      when 'selectbox', 'radio'
        value_isNull = que_answer[:question_choice_id].blank?
        unless value_isNull
          question_answer_id = create_simple_que_answer(question_id)
          answer_choice_params = que_answer.permit(:question_choice_id)
          answer_choice_params[:question_answer_id] = question_answer_id
          AnswerChoice.create(answer_choice_params)
        end
      when 'checkbox'
        value_isNull = que_answer.length <= 1
        unless value_isNull
          question_answer_id = create_simple_que_answer(question_id)
          que_answer.each_key do |index|
            next if index == 'category'
            answer_choice_params = que_answer[index].permit(:question_choice_id)
            answer_choice_params[:question_answer_id] = question_answer_id
            AnswerChoice.create(answer_choice_params)
          end
        end
      end
    end

    def update_que_answer(key, question_id, question_answers)
      que_answer = params.require(:answer).require(key.to_sym)
        case que_answer[:category]
        when 'input', 'textarea'
          question_answer_id = question_answers.find_by(question_id: question_id).id
          answer_text = AnswerText.find_by(question_answer_id: question_answer_id)
          answer_text.update(que_answer.permit(:body))
        when 'selectbox', 'radio'
          question_answer_id = question_answers.find_by(question_id: question_id).id
          answer_choice = AnswerChoice.find_by(question_answer_id: question_answer_id)
          answer_choice.destroy
          AnswerChoice.create(choice_params(key, question_answer_id))
        when 'checkbox'
          question_answer_id = question_answers.find_by(question_id: question_id).id
          answer_choices = AnswerChoice.where(question_answer_id: question_answer_id)
          answer_choices.delete_all
          que_answer.each_key do |index|
            next if index == 'category'
            answer_params = que_answer[index].permit(:question_choice_id)
            answer_params[:question_answer_id] = question_answer_id
            AnswerChoice.create(answer_params)
          end
        end
    end

    def update_temporary_que_answer(key, question_id, question_answers)
      que_answer = params.require(:answer).require(key.to_sym)
      question_answer = question_answers.find_by(question_id: question_id)
      case que_answer[:category]
      when 'input', 'textarea'
        value_isNull = que_answer[:body].empty?
        unless value_isNull
          answer_text = AnswerText.find_by(question_answer_id: question_answer.id)
          answer_text.update(que_answer.permit(:body))
        end
      when 'selectbox', 'radio'
        value_isNull = que_answer[:question_choice_id].blank?
        unless value_isNull
          answer_choice = AnswerChoice.find_by(question_answer_id: question_answer.id)
          answer_choice.destroy
          AnswerChoice.create(choice_params(key, question_answer.id))
        end
      when 'checkbox'
        value_isNull = que_answer.length <= 1
        unless value_isNull
          answer_choices = AnswerChoice.where(question_answer_id: question_answer.id)
          answer_choices.delete_all
          que_answer.each_key do |index|
            next if index == 'category'
            answer_params = que_answer[index].permit(:question_choice_id)
            answer_params[:question_answer_id] = question_answer_id
            AnswerChoice.create(answer_params)
          end
        end
      end
      question_answer.destroy if value_isNull
    end

    def create_simple_que_answer(question_id)
      question_answer = QuestionAnswer.create(question_id: question_id, user_id: current_user.id)
      question_answer.id
    end

    def choice_params(key, question_answer_id)
      params.require(:answer).require(key.to_sym)[:question_answer_id] = question_answer_id
      params.require(:answer).require(key.to_sym).permit(:question_choice_id, :question_answer_id)
    end
end
