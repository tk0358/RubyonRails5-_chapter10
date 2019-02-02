# 10-7-2-2
# case2 オブジェクトの内部状態を変更するコードをモデルに寄せる
# 変更前コントローラ app/controllers/articles_controller.rb

# ユーザーがブログ記事を柿、公開出来る機能があるとする。
# この公開機能を、ArticlesControllerのpublishアクションで実現している。
#  publishアクションでは次の処理を行う。
#  1. 記事のstatusを確認し、下書き（draft）なら記事を公開（published）状態にして公開日時を設定する。下書き状態でなければエラーを出す。
#  2. 期間限定の記事（article.limited == true）の場合は、公開終了日時（expres_at）を３ヶ月後の月末にする

class ArticlesController < ApplicationController
  def publish
    unless @article.status == 'draft'
      redirect_to @article, alert: '下書きの記事のみ公開にできます'
      return
    end

    @article.status = 'published'  # <-
    @article.published_at = Time.current # <-

    if @article.limited?
      @article.expires_at = (@article.published_at + 3.months).end_of_month # <-
    end

    @article.save

    redirect_to @article, notice: '記事を公開しました'
  end
end

# <- の箇所に注目。
# @articleのようなモデルオブジェクトのインスタンス変数に対するメソッド呼び出しが連続しているような箇所は、モデル側に移した方がよい場合が多い。
