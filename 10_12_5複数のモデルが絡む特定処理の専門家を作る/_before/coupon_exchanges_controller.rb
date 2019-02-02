=begin
対等な関係の複数のモデルを操作しなければならない場面に出くわす。
例えば、あるアプリケーションではポイントをためてクーポンと交換することができ、
その際は次のような仕様になっているとする。
1. ユーザーは保有するポイントのうち、一定ポイントと引き換えにクーポンを取得する。
2. クーポン取得に必要なポイントが足りない場合にエラーとする
3. クーポンは数に限りがあり、残量がない場合にエラーとする

登場するモデルは「ユーザー」と「クーポン」。
この２つのモデルは強い関係性があるわけではないため、
ユーザーモデルの立場では、クーポンの数に限りがあるというような事情にはできるだけ関知したくない。
また、クーポンモデルの立場では、ユーザーの保有ポイントには立ち入りたくない。
これらはそれぞれ、相手のモデルの管理すべき事項であり、立ち入ると依存関係が強まってしまうから。

このような処理はどこに実装すべきか？
素直にコントローラに記述すると、次のような実装になる。
=end

class CouponExchangeController < ApplicationController
  def create
    coupon = Coupon.available.where(code: params[:code]).first

    unless coupon
      redirect_to({ action: :new }, alert: '当該クーポンの発行は終了しました')
      return
    end

    unless current_user.withdrawable_point?(coupon.required_point)
      redirect_to({ action: :new }, alert: 'クーポンの取得に必要なポイントが足りません')
      return
    end

    begin
      ActiveRecord::Base.transaction do
        current_user.withdraw_point(coupon.required_point)
        coupon.give_to(current_user)
      end
    rescue => e
      redirect_to({ action: :new }, alert: 'クーポンの取得に失敗しました')
      logger.error e.full_message
      return
    end

    redirect_to({ action: :new }, notice: 'クーポンを取得しました')
  end
end

=begin
このようなコントローラはモデルに命令を出すという本来のシンプルな役割を超えて、様々なことを処理している。
どんなときにポイント交換できるのか、また、モデルたちをどの順序で、どういうときにどう呼ばばよいのか、というビジネスロジックを司ってしまっている。
これではせっかくMVCを分けているメリットを享受できず、メンテナンスコストを上げ、テストをしづらくしてしまう。

かといって、既存のモデルにコードを書くことも選択しづらい状況。
ユーザーとクーポンのどちらに書いても、もう片方のモデルに対する依存性を高めてしまうし、あとから参照する際にも、当該処理がどちらに実装されているかを予測しづらくなってしまう。

こんなときは、この「クーポン交換」という特定の処理の専門家クラスを用意してみよう。
CouponExchangesControllerに直接書かれていた処理を、CouponExchangeというくらすに抜き出す(→after/coupon_exchange.rb)
=end
