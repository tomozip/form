# frozen_string_literal: true

require 'spec_helper'

describe AnswersController do
  let(:user) { create :user }
  let(:questionnaire) { create :questionnaire }
  before do
    login_user(user)
  end

  shared_examples_for 'general test' do |templete|
    it 'returns http success' do
      expect(response.status).to eq(200)
    end
    it 'render correct templete' do
      expect(response).to render_template templete if templete.present?
    end
  end

  describe "GET 'new'" do
    before do
      get :new, user_id: user.id, questionnaire_id: questionnaire.id
    end
    it 'does something' do
      expect(response).to redirect_to new_user_questionnaire_answer_path(user.id, questionnaire.id)
    end
    # it_behaves_like 'general test', :index
  end

  # describe "GET 'show'" do
  #   it 'returns http success' do
  #     get 'show'
  #     response.should be_success
  #   end
  # end
  #
  # describe "GET 'create'" do
  #   it 'returns http success' do
  #     get 'create'
  #     response.should be_success
  #   end
  # end
end
