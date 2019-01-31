# 10-7-2-2
# case2 オブジェクトの内部状態を変更するコードをモデルに寄せる
# 変更後コントローラ app/controllers/articles_controller.rb

# # コントローラの基本的な仕事の１つは画面を表示したりリダイレクトを行うことだが、
# リファクタリング後のコードでは、その本来の役割だけが残ったきれいな状態になっている

class ArticlesController < ApplicationController
  def publish
    if @article.publish
      redirect_to @article, notice: '記事を公開しました'
    else
      redirect_to @article, alert: '下書きの記事のみ公開にできます'
    end
  end
end
