# frozen_string_literal: true

require 'spec_helper'

describe AnswersController do
  let(:user) { create :user }
  let(:questionnaire) { create :questionnaire }
  let(:params) { { user_id: user.id, questionnaire_id: questionnaire.id } }

  before { login_user(user) }

  shared_examples 'render template' do |template|
    it do
      action
      expect(response).to render_template template
    end
  end

  shared_examples '.form_set' do
    let!(:select_question) { create :select_question, questionnaire: questionnaire }
    let!(:checkbox_question) { create :checkbox_question, questionnaire: questionnaire }

    before { action }

    it 'assign user' do
      expect(assigns(:user)).to eq user
    end

    it 'assign questionnaire' do
      expect(assigns(:questionnaire)).to eq questionnaire
    end

    it 'assign options' do
      expect(assigns(:options)).to eq(select_question.id.to_s => select_question.question_choices,
                                      checkbox_question.id.to_s => checkbox_question.question_choices)
    end
  end

  describe 'GET #new' do
    let(:action) { get :new, params: params }

    it 'assign answer' do
      action
      expect(assigns(:answer)).to be_new_record
    end

    it_behaves_like '.form_set'
    it_behaves_like 'render template', :new
  end

  describe 'GET #edit' do
    let(:action) { get :edit, params: params }

    it 'assign answer' do
      answer = create :answer, user: user, questionnaire: questionnaire
      action
      expect(assigns(:answer)).to eq answer
    end

    it 'assign answered_question_ids' do
      text_question = create :text_question, questionnaire: questionnaire
      text_qa = create :text_qa, user: user, question: text_question
      action
      expect(assigns(:answered_question_ids)).to eq [text_question.id]
    end

    it 'call QuestionAnswer.prepare_answers' do
      allow(QuestionAnswer).to receive(:prepare_answers).and_return('done')
      expect(QuestionAnswer).to receive(:prepare_answers).once
      action
    end

    it_behaves_like '.form_set'
    it_behaves_like 'render template', :edit
  end

  describe 'GET #show' do
    let(:action) { get :show, params: params }

    before do
      allow(CompaniesUser).to receive(:prepare_member_results).and_return('done')
    end

    it 'assign questionnaire' do
      action
      expect(assigns(:questionnaire)).to eq questionnaire
    end

    it 'call CompaniesUser.prepare_member_results' do
      expect(CompaniesUser).to receive(:prepare_member_results).once
      action
    end

    it_behaves_like 'render template', 'questionnaires/result'
  end

  let(:create_params) { { answer: 'answer', user_id: user.id.to_s, questionnaire_id: questionnaire.id.to_s } }

  shared_examples 'redirect successfully' do
    it do
      action
      expect(response).to redirect_to questionnaire_list_user_questionnaires_path
    end
  end

  describe 'POST #create' do
    let(:action) { post :create, params: params }

    before do
      params[:answer] = 'answer'
      allow(Answer).to receive(:create_with_que_answer).with(create_params).and_return(true)
      allow(Answer).to receive(:tem_create_with_que_answer).with(create_params).and_return(true)
    end

    context 'without tmp' do
      it 'call Answer.tem_create_with_que_answer' do
        expect(Answer).to receive(:create_with_que_answer).once
        action
      end
      it_behaves_like 'redirect successfully'
    end

    context 'with tmp' do
      it 'call Answer.create_with_que_answer' do
        params[:temporary] = 'tmp'
        expect(Answer).to receive(:tem_create_with_que_answer).once
        action
      end
      it_behaves_like 'redirect successfully'
    end
  end

  describe 'PATCH #update' do
    let(:action) { patch :update, params: params }

    before do
      params[:answer] = 'answer'
      allow(Answer).to receive(:update_with_que_answer).with(create_params).and_return(true)
      allow(Answer).to receive(:tem_update_with_que_answer).with(create_params).and_return(true)
    end

    context 'without tmp' do
      it 'call Answer.tem_create_with_que_answer' do
        expect(Answer).to receive(:update_with_que_answer).once
        action
      end
      it_behaves_like 'redirect successfully'
    end

    context 'with tmp' do
      it 'call Answer.create_with_que_answer' do
        params[:temporary] = 'tmp'
        expect(Answer).to receive(:tem_update_with_que_answer).once
        action
      end
      it_behaves_like 'redirect successfully'
    end
  end
end
