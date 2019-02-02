# app/models/stock.rb

require 'net/http'

class Stock
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveModel::Serializers::JSON
  attr_accessor :product_code, quantity
  attribute :verified, :boolean

  validates :product_code, presence: true
  validates :quantity, presence: true, numericality: { greater_than_or_equal: 1 }

  def save
    validate && post
  end

  private

  # ActiveModel::Serializers::JSON用にシリアライズ法を指定
  def attributes
    { product_code: product_code, quantity: quantity, verified: verified }
  end

  def post
    begin
      response = Net::HTTP.post(
        URI('http://localhost:1323/stocks'),
        to_json, # 「attributes」メソッドの指定に従ってシリアライズ
        "Content-Type" => "application/json"
      )
    rescue => e
      errors.add(:base, '在庫管理システムに接続できませんでした。')
      Rails.logger.error e.full_message
    end

    return true if response.code == '200'

    assign_response_errors(response)
    false
  end

  def assign_response_errors(response)
    error_code = JSON.parse(response.body)['error_code']

    error_message =
      case error_code
      when 'product_not_found'
        "指定の商品は存在しません。"
      when 'product_unavailable'
        "取扱終了商品です。"
      else
        "エラーが発生しました。code = #{error_code}"
      end

    errors.add(:base, error_message)
  end
end

=begin
これで、プログラマは外部サービスを呼び出すということをそれほど意識せずに、
Stockモデルオブジェクトを作ってパラメータを渡し、検証と保存を行い、
検証または保存に失敗した場合にはエラー詳細を取り出すことが出来るようになる。

なお、params[:stock]というパラメータのかたまりに着目してStockモデルを抽出するという点で、
このやり方は「意味のあるパラメータの集合からクラスを生み出す」で説明した内容とも似ていると言える。

Stockモデルを利用するコントローラ側は次のように変更する()→after/stocks_controller.rb)
=end
