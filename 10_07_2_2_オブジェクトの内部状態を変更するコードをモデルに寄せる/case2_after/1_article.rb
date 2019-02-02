# 10-7-2-2
# case2 オブジェクトの内部状態を変更するコードをモデルに寄せる
# 変更後モデル app/models/article.rb

# 表における「統合的メソッドを追加する」という作戦を取る。
# 「下書き状態なら公開処理を行う。期間限定の記事の場合は公開終了日時を設定する」という仕事を行うpublishというメソッドをArticleモデルに追加する

class Article < ApplicationRecord
  def publish
    return false unless status == 'draft'

    self.status = 'published'
    self.published_at = Time.current

    if limited?
      self.expires_at = (published_at + 3.months).end_of_month
    end

    save
  end
end

# Articleモデルをこのようにすることで、ArticlesController側は非常にすっきりする
