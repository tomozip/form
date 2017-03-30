class Question < ApplicationRecord
  belongs_to :questionnaire
  enum category: { input: 0, textarea: 1, checkbox: 2, select: 3, radio: 4}
end
