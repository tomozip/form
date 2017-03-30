class QuestionnairesController < ApplicationController

  def index
    @questionnaires = Questionnaire.all
  end

  def new
    @questionnaire = Questionnaire.new
  end

  def create

  end

  def destroy

  end

end
