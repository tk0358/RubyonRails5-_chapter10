class ArticlesController < ApplicationController
  def index
    @search_form = ArticleSearchForm.new(params[:search])
    @articles = @search_form.search
  end
end

# 意味のつながりのあるパラメータを扱う専用のモデルクラスを追加すると、
# パラメータで運ばれているデータと処理をうまくカプセル化してコントローラから分離することができる。
# また、ActiveModelの機能を活用して、パラメータチの変換や検証といった処理も簡単に行う事ができる。
