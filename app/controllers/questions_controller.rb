class QuestionsController < ApplicationController
  def create
    questionnaire = Questionnaire.find(params[:questionnaire_id])
    @question = questionnaire.questions.new(question_params)
    if @question.save
      create_choices(question.id) unless params[:question][:question_choices].nil?
      redirect_to questionnaire_path(params[:questionnaire_id])
    else
      render_questionnaire_index
    end
  end

  def destroy
  end

  private
    def question_params
      params.require(:question).permit(:body, :category)
    end

    def create_choices(question_id)
      numChoice = params.require(:question).require(:question_choices).length
      numChoice.times do |i|
        key = "choice#{i}"
        question_choice_params = params.require(:question)
                                       .require(:question_choices)[key]
                                       .permit(:body)
        question_choice_params['question_id'] = question_id
        @question_choice.new(question_choice_params)
        unless @question_choice.save
          render_questionnaire_index
        end
      end
    end

    def render_questionnaire_index
      @questionnaires = Questionnaire.all
      @questionnaire = Questionnaire.new
      render 'questionnaire/index'
    end

end
