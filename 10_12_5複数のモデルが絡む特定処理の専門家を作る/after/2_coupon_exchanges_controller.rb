# app/controllers/coupon_exchange_controller.rb (変更後)

class CouponExchangeController < ApplicationController
  def create
    coupon = Coupon.available.where(code: params[:code]).first
    exchange = CouponExchange.new(coupon, current_user)

    if exchange.execute
      redirect_to({ action: :new }, notice: 'クーポンを取得しました')
    else
      redirect_to({ action: :new }, alert: exchange.error)
    end
  end
end

=begin
このようにすると、コントローラはレスポンスの作成に必要な情報をこの処理の専門家であるCouponExchangeクラスに命令するだけで得られるようになり、一気に見通しがよくなったことが分かる。

また、業務内容に直接対応する「CouponExchange」という名前をモデルクラスにつけることで、
「クーポンを交換する」ということが呼び出し側から連想しやすくなっている。
連想しやすい名前のクラスは読みやすく、修正が必要になった時に、対応する修正箇所を見つけやすいため、メンテナンス性を向上させる。

なお、このように特定の処理の専門家のオブジェクトを作成する設計パターンをサービスオブジェクト（またはサービスクラス）と呼ぶことがある。
=end
