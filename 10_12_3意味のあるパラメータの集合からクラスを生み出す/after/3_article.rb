class Article < ApplicationRecord
  scope :matches, ->(keyword) { where("title LIKE ?", "%#{keyword}%").or(where("body LIKE ?", "%#{keyword}%")) }
  scope :with_draft, ->(user) { where(user: user).or(where(status: 'draft')) }
  scope :published, -> { where(status: 'published') }
end

# orメソッドは、「OR」演算子を使ったSQLを出力するメソッド
# article.rbはそのまま
