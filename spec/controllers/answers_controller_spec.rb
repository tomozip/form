# frozen_string_literal: true

require 'spec_helper'

describe AnswersController do
  let(:user) { create :user }
  let(:questionnaire) { create :questionnaire }

  before { login_user(user) }

  describe 'GET #new' do
    let(:params) { { user_id: user.id, questionnaire_id: questionnaire.id } }

    before { get :new, params: params }

    it 'assign answer' do
      # get :new, params: params
      expect(assigns(:answer)).to be_new_record
    end
  end
end
