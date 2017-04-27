# frozen_string_literal: true

require 'spec_helper'

feature 'User log in' do
  scenario 'log in company', open_on_error: true do
    company = create :company, name: 'company1', password: 'pass1'
    allow(UserMailer).to receive(:welcome_email).and_return(true)
    allow(true).to receive(:deliver_now).and_return(true)

    visit root_path

    click_link '新規登録'
    select 'company1', from: 'session_company_id'
    fill_in 'session_password', with: 'pass1'
    click_button '新規登録ページへ'

    expect(current_path).to eq new_user_registration_path

    expect{
      fill_in 'user_name', with: 'user_name'
      fill_in 'user_email', with: 'user@gmail.com'
      fill_in 'user_password', with: 'user_password'
      fill_in 'user_password_confirmation', with: 'user_password'
      click_button '登録'
    }.to change { User.count }.by(1)
    expect(current_path).to eq user_path('1')
    expect(page).to have_content 'ユーザートップページ'
    expect(page).to have_content 'company1'
    expect(page).to have_content 'アカウントを作成しました。'
  end
end
