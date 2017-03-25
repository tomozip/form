module SessionsHelper
  # 渡されたユーザーでログインする
  def log_in(user)
    session[:company_id] = company.id
  end

  # 現在ログインしているユーザーを返す (ユーザーがログイン中の場合のみ)
  def current_user
    @current_company ||= Company.find_by(id: session[:company_id])
  end

  # ユーザーがログインしていればtrue、その他ならfalseを返す
  def logged_in?
    !current_company.nil?
  end

  # 現在のユーザーをログアウトする
  def log_out
    session.delete(:company_id)
    @current_company = nil
  end

end
