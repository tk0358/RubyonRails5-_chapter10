=begin
一覧画面での絞り込み機能（検索機能）
検索エリアがあり、記事（Article）をタイトル、本文のいずれか指定されたキーワードを含むかどうかで検索できるものとする。
また「下書きを含める」をチェックすると、自分の描いた下書き記事を含めて検索出来るものとする。

このような検索欄の検索ボタンを押したときに、必要に応じて絞り込みを行って記事一覧を表示するためのArticlesControllerのindexアクションと、Articleモデルクラスが以下のようになっている。
=end

class ArticlesController < ApplicationController
  def index
    scope = Article.all

    if params[:keyword].present?
      scope = scope.matches(params[:keyword])
    end

    if params[:draft] == '1'
      scope = scope.with_draft(user)
    else
      scope = scope.published
    end

    @articles = scope
  end
end

=begin
上のアクションでは、params[:keyword]とparams[:draft]という２つの絞り込み用のパラメータを使って検索条件を組み立て、記事リスト（@articles）を取得しているが、パラメータごとに多少の処理を書く必要があり、コードが複雑になってしまっている。

このような時は、params[:keyword]もparams[:draft]も検索条件である、という意味のまとまりに着目し、これらを運ぶためのモデルクラスを作るとうまくいく。（→after/article_serarch_form.rb)
=end
