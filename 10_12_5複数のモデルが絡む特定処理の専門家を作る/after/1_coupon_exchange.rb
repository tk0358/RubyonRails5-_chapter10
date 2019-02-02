# app/models/coupon_exchange.rb

class CouponExchange
  attr_reader :error

  def initialize(coupon, user)
    @coupon = coupon
    @user = user
  end

  def execute
    unless @coupon
      @error = '当該クーポンの発行は終了しました'
      return false
    end

    unless @user.withdrawable_point?(@coupon.required_point)
      @error = 'クーポンの取得に必要なポイントが足りません'
    end

    begin
      ActiveRecord::Base.transaction do
        @user.withdraw_point(@coupon.required_point)
        @coupon.give_to(@user)
      end
    rescue => e
      @error = 'クーポンの取得に失敗しました'
      Rails.logger.error e.full_message
      return false
    end

    true
  end
end

# このように抽出したCouponExchangeモデルクラスは、CouponExchangesControllerから利用できる(-> after/coupon_exchange_controller.rb)
