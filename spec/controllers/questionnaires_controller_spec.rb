# frozen_string_literal: true

require 'spec_helper'

describe QuestionnairesController do
  let(:admin) { create :admin }
  let(:user) { create :user }
  let(:questionnaire) { create :questionnaire }

  before { |example| example.metadata[:user] ? login_user(user) : login_admin(admin) }

  shared_examples 'render template' do |template|
    it do
      expect(response).to render_template template
    end
  end

  shared_examples 'assigns questionnaire' do
    it do
      expect(assigns(:questionnaire)).to eq questionnaire
    end
  end

  describe 'GET #index' do
    before { get :index }

    it 'assigns questionnaire' do
      expect(assigns(:questionnaire)).to be_new_record
    end

    it_behaves_like 'render template', :index
  end

  describe 'GET #show' do
    before { get :show, params: { id: questionnaire.id } }

    it_behaves_like 'assigns questionnaire'
    it_behaves_like 'render template', :show
  end

  describe 'GET #result' do
    it 'call Answer.prepare_answer_result with params' do
      create :answer, user: user, questionnaire: questionnaire, status: 'answered'
      expect(Answer).to receive(:prepare_answer_result).with(questionnaire.questions, [user.id]).once
      get :result, params: { id: questionnaire.id }
    end

    before do
      allow(Answer).to receive(:prepare_answer_result).and_return(true)
      get :result, params: { id: questionnaire.id }
    end

    it_behaves_like 'assigns questionnaire'
    it_behaves_like 'render template', :result
  end

  describe 'GET #update_status' do
    before { get :update_status, params: { id: questionnaire.id } }

    it "changes @contact's attributes" do
      questionnaire.reload
      expect(questionnaire.status).to eq 'sent'
    end

    it 'redirect successfully' do
      expect(response).to redirect_to questionnaires_path
    end

    it 'has flash message' do
      expect(flash[:notice]).to eq 'アンケートを発行しました。'
    end

    it_behaves_like 'assigns questionnaire'
  end

  describe 'GET #questionnaire_list' do
    let(:questionnaire2) { create :questionnaire }

    it 'call Questionnaire.prepare_questionnaire_list with params', :user do
      create :answer, user: user, questionnaire: questionnaire, status: 'answering'
      create :answer, user: user, questionnaire: questionnaire2, status: 'answered'
      expect(Questionnaire).to receive(:prepare_questionnaire_list)
        .with([questionnaire.id], [questionnaire2.id])
      get :questionnaire_list, params: { user_id: user.id }
    end

    it 'render template', :user do
      get :questionnaire_list, params: { user_id: user.id }
      expect(response).to render_template 'answers/questionnaire_list'
    end
  end

  describe 'POST #create' do
    before { post :create, params: { questionnaire: questionnaire_params } }

    context 'valid attributes' do
      let(:questionnaire_params) { attributes_for(:questionnaire) }

      it 'create new questionnaire' do
        expect { post :create, params: { questionnaire: questionnaire_params } }
          .to change { Questionnaire.count }.by(1)
      end

      it 'redirect successfully' do
        expect(response).to redirect_to questionnaire_path(questionnaire.id - 1)
      end
    end

    context 'invalid attributes' do
      let(:questionnaire_params) { attributes_for(:questionnaire, title: nil) }

      it 'does not create new questionnaire' do
        expect { post :create, params: { questionnaire: questionnaire_params } }
          .not_to change { Questionnaire.count }
      end

      it_behaves_like 'render template', :index
    end
  end

  describe 'POST #ajax_form' do
    let(:params) { { id: questionnaire.id, category_select: 'category', num_choice: 1 } }

    before { post :ajax_form, params: params }

    it 'assigns question_info' do
      expect(assigns(:question_info)).to eq(category: 'category', num_choice: '1')
    end

    it 'assigns question' do
      expect(assigns(:question)).to be_new_record
      expect(assigns(:question).questionnaire_id).to eq questionnaire.id
    end

    it_behaves_like 'assigns questionnaire'
    it_behaves_like 'render template', :show
  end

  describe 'DELETE #destroy' do
    subject { delete :destroy, params: { id: questionnaire.id } }

    it 'delete questionnaire' do
      questionnaire
      expect { subject }.to change { Questionnaire.count }.by(-1)
    end

    it 'redirect successfully' do
      subject
      expect(response).to redirect_to questionnaires_path
    end
  end
end
