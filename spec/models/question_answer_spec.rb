# frozen_string_literal: true

require 'spec_helper'

describe QuestionAnswer do
  it 'has a valid factory' do
    expect(build(:question_answer)).to be_valid
  end

  it 'is invalid without a question_id' do
    question_answer = build(:question_answer, question_id: nil)
    question_answer.valid?
    expect(question_answer.errors[:question_id]).to include('を入力してください')
  end

  it 'is invalid without a user_id' do
    question_answer = build(:question_answer, user_id: nil)
    question_answer.valid?
    expect(question_answer.errors[:user_id]).to include('を入力してください')
  end

  it 'does not allow duplicate user_id&question_id' do
    user = create(:user)
    question = create(:question)
    create(:question_answer, user: user, question: question)
    question_answer = build(:question_answer, user: user, question: question)
    question_answer.valid?
    expect(question_answer.errors[:user_id]).to include('はすでに存在します')
  end

  describe '(method to create or update)' do
    let(:user) { create :user }
    let(:question_choice) { create :question_choice }
    let(:que_answer) { ActionController::Parameters.new(params_content) }

    shared_context 'when input or textarea' do
      let(:question) { create :text_question }
    end
    shared_context 'when selectbox or radio' do
      let(:question) { create :select_question }
    end
    shared_context 'when checkbox' do
      let(:question) { create :checkbox_question }
    end
    shared_context 'with valid attributes of text' do
      let(:params_content) { { category: 'input', body: 'ParamsString' } }
    end
    shared_context 'with invalid attributes of text' do
      let(:params_content) { { category: 'input', body: nil } }
    end
    shared_context 'with valid attributes of select' do
      let(:params_content) { { category: 'selectbox', question_choice_id: question.question_choices.find_by(body: 'qc1').id } }
    end
    shared_context 'with invalid attributes of select' do
      let(:params_content) { { category: 'selectbox', question_choice_id: nil } }
    end
    shared_context 'with valid attributes of checkbox' do
      let(:params_content) do
        { category: 'checkbox',
          '0' => { question_choice_id: question.question_choices.find_by(body: 'qc1').id },
          '1' => { question_choice_id: question.question_choices.find_by(body: 'qc2').id } }
      end
    end
    shared_context 'with invalid attributes of checkbox' do
      let(:params_content) { { category: 'checkbox' } }
    end

    describe '(create question_answer with childs)' do
      shared_examples 'saves the new question_answer & answer_text' do
        it 'saves the new question_answer & answer_text' do
          expect { described_subject }.to change { described_class.count }.by(1).and \
            change { AnswerText.count }.by(1)
        end
      end
      shared_examples 'saves the new question_answer & answer_choice' do
        it 'saves the new question_answer & answer_choice' do
          expect { described_subject }.to change { described_class.count }.by(1).and \
            change { AnswerChoice.count }.by(1)
        end
      end
      shared_examples 'saves the new question_answer & answer_choices' do
        it 'saves the new question_answer & answer_choices' do
          expect { described_subject }.to change { described_class.count }.by(1).and \
            change { AnswerChoice.count }.by(2)
        end
      end

      describe '.create_with_childs' do
        subject(:described_subject) do
          described_class.create_with_childs(question.id.to_s, que_answer, user.id)
        end
        context 'when input or textarea' do
          include_context 'when input or textarea'
          context 'with valid attributes' do
            include_context 'with valid attributes of text'
            it_behaves_like 'saves the new question_answer & answer_text'
          end
          context 'with invalid attributes' do
            include_context 'with invalid attributes of text'
            it 'raise RecordInvalid error' do
              expect { described_subject }.to raise_error(ActiveRecord::RecordInvalid)
            end
          end
        end

        context 'when selectbox or radio' do
          include_context 'when selectbox or radio'
          context 'with valid attributes' do
            include_context 'with valid attributes of select'
            it_behaves_like 'saves the new question_answer & answer_choice'
          end
          context 'with invalid attributes' do
            include_context 'with invalid attributes of select'
            it 'raise RecordInvalid error' do
              expect { described_subject }.to raise_error(ActiveRecord::RecordInvalid)
            end
          end
        end

        context 'when checkbox' do
          include_context 'when checkbox'
          context 'with valid attributes' do
            include_context 'with valid attributes of checkbox'
            it_behaves_like 'saves the new question_answer & answer_choices'
          end
          context 'with invalid attributes' do
            include_context 'with invalid attributes of checkbox'
            it 'raise RuntimeError, "No checked choice"' do
              expect { described_subject }.to raise_error(RuntimeError, 'No checked choice')
            end
          end
        end
      end

      describe '.tem_create_with_childs' do
        subject(:described_subject) do
          described_class.tem_create_with_childs(question.id.to_s, que_answer, user.id)
        end
        context 'when input or textarea' do
          include_context 'when input or textarea'
          context 'with valid attributes' do
            include_context 'with valid attributes of text'
            it_behaves_like 'saves the new question_answer & answer_text'
          end
          context 'with invalid attributes' do
            include_context 'with invalid attributes of text'
            it 'does not save the new question_answer or answer_text' do
              expect { described_subject }.not_to  change { described_class.count }
              expect { described_subject }.not_to  change { AnswerText.count }
            end
          end
        end

        context 'when selectbox or radio' do
          include_context 'when selectbox or radio'
          context 'with valid attributes' do
            include_context 'with valid attributes of select'
            it_behaves_like 'saves the new question_answer & answer_choice'
          end
          context 'with invalid attributes' do
            include_context 'with invalid attributes of select'
            it 'does not save the new question_answer or answer_choice' do
              expect { described_subject }.not_to  change { described_class.count }
              expect { described_subject }.not_to  change { AnswerChoice.count }
            end
          end
        end

        context 'when checkbox' do
          include_context 'when checkbox'
          context 'with valid attributes' do
            include_context 'with valid attributes of checkbox'
            it_behaves_like 'saves the new question_answer & answer_choices'
          end
          context 'with invalid attributes' do
            include_context 'with invalid attributes of checkbox'
            it 'does not save the new question_answer or answer_choices' do
              expect { described_subject }.not_to  change { described_class.count }
              expect { described_subject }.not_to  change { AnswerChoice.count }
            end
          end
        end
      end
    end

    describe '(update question_answer with childs)' do
      let(:question_answer) do
        if question.category == 'input'
          create :text_qa, user: user, question: question
        else
          create :question_answer, user: user, question: question
        end
      end
      # #DOING:20 update処理のshared_examplesの用意
      shared_examples 'update answer_text' do
        it 'update answer_text' do
          expect { described_subject }.to change { question_answer.reload.answer_text.body }.from('MyString').to('ParamsString')
        end
      end
      # DOING:0 tem_update_with_childsのinvalidの時に移植。普通のupdateではエラー出すことにしたから。
      shared_examples 'update answer_choice' do
        it 'delete pre_answer_choice and create new answer_choice' do
          expect { described_subject }.to change { question_answer.answer_choices.first.question_choice.body }.from('qc0').to('qc1')
          expect { described_subject }.not_to change { described_class.count }
        end
      end
      shared_examples 'update answer_choices' do
        it 'delete pre_answer_choices and create new answer_choices' do
          expect { described_subject }.to change { question_answer.reload.answer_choices[0].question_choice.body }.from('qc0').to('qc1').and \
            change { question_answer.answer_choices[1].question_choice.body }.from('qc1').to('qc2')
          expect { described_subject }.not_to change { described_class.count }
        end
      end

      describe '.update_with_childs' do
        subject(:described_subject) do
          described_class.update_with_childs(que_answer, question_answer.id)
        end
        shared_examples 'fail to update because of nil' do
          it do
            expect { described_subject }.to raise_error('que_answer is nil')
          end
        end
        context 'when input or textarea' do
          include_context 'when input or textarea'
          context 'with valid attributes' do
            include_context 'with valid attributes of text'
            it_behaves_like 'update answer_text'
          end
          context 'with invalid attributes' do
            include_context 'with invalid attributes of text'
            it_behaves_like 'fail to update because of nil'
          end
        end

        context 'when selectbox or radio' do
          include_context 'when selectbox or radio'
          before do
            create(:answer_choice,
                   question_answer: question_answer,
                   question_choice: question.question_choices.find_by(body: 'qc0'))
          end
          context 'with valid attributes' do
            include_context 'with valid attributes of select'
            it_behaves_like 'update answer_choice'
          end
          context 'with invalid attributes' do
            include_context 'with invalid attributes of select'
            it_behaves_like 'fail to update because of nil'
          end
        end

        context 'when checkbox' do
          include_context 'when checkbox'
          before do
            create(:answer_choice,
                   question_answer: question_answer,
                   question_choice: question.question_choices.find_by(body: 'qc0'))
            create(:answer_choice,
                   question_answer: question_answer,
                   question_choice: question.question_choices.find_by(body: 'qc1'))
          end
          context 'with valid attributes' do
            include_context 'with valid attributes of checkbox'
            it_behaves_like 'update answer_choices'
          end
          context 'with invalid attributes' do
            include_context 'with invalid attributes of checkbox'
            it_behaves_like 'fail to update because of nil'
          end
        end
      end

      describe '.tem_update_with_childs' do
        # TODO: 一時アップデート。のテストを書く
        subject(:described_subject) do
          described_class.tem_update_with_childs(que_answer, question_answer)
        end
        shared_examples 'delete question_answer' do
          it do
            question_answer
            expect { described_subject }.to change { described_class.count }.by(-1)
          end
        end
        context 'when input or textarea' do
          include_context 'when input or textarea'
          context 'with valid attributes' do
            include_context 'with valid attributes of text'
            it_behaves_like 'update answer_text'
          end
          context 'with invalid attributes' do
            include_context 'with invalid attributes of text'
            it_behaves_like 'delete question_answer'
          end
        end

        context 'when selectbox or radio' do
          include_context 'when selectbox or radio'
          before do
            create(:answer_choice,
                   question_answer: question_answer,
                   question_choice: question.question_choices.find_by(body: 'qc0'))
          end
          context 'with valid attributes' do
            include_context 'with valid attributes of select'
            it_behaves_like 'update answer_choice'
          end
          context 'with invalid attributes' do
            include_context 'with invalid attributes of select'
            it_behaves_like 'delete question_answer'
          end
        end

        context 'when checkbox' do
          include_context 'when checkbox'
          before do
            create(:answer_choice,
                   question_answer: question_answer,
                   question_choice: question.question_choices.find_by(body: 'qc0'))
            create(:answer_choice,
                   question_answer: question_answer,
                   question_choice: question.question_choices.find_by(body: 'qc1'))
          end
          context 'with valid attributes' do
            include_context 'with valid attributes of checkbox'
            it_behaves_like 'update answer_choices'
          end
          context 'with invalid attributes' do
            include_context 'with invalid attributes of checkbox'
            it_behaves_like 'delete question_answer'
          end
        end
      end
    end
  end
end
