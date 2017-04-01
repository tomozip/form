module ApplicationHelper

  def to_text(category)
    case category
    when 'input'
      "自由記入(短文)"
    when 'textarea'
      '自由記入'
    when 'checkbox'
      '複数選択'
    when 'selectbox'
      '一択(セレクトボックス)'
    when 'radio'
      '一択(チェックボックス)'
    end
  end

end
