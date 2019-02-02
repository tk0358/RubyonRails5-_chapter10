class StocksController < ApplicationController
  def create
    stock = Stock.new(stock_params)

    if stock.save
      redirect_to new_stock_url, flash: { success: "在庫作成が完了しました！" }
    else
      flash.now[:alert] = stock.errors.full_messages.join
      render :new
    end
  end

  private

  def stock_params
    params.require(:stock).permit(:product_code, :quantity, :verified)
  end
end

=begin
ごくシンプルに、通常のCRUD機能のような実装になった！
Stock#saveの呼び出しの成否によってflashの内容が変化するという処理の流れがひと目で分かる。

このように、外部サービスに関連するロジックを暮らすに閉じ込めることには、
コントローラが複雑になることを防ぐ以外にも次の２点でメリットがある。
1. ダミー実装と入れ替えやすくなる。
2. テストがしやすくなる

Stockクラスとして切り出した範囲は、その部分をモックにするなどして動作を確認することが出来る。
つまり、たとえ在庫管理APIがまだ未実装だったとしても、次の用にダミーオブジェクトを用意してアプリケーションの実装を進めることが出来る
=end

# 在庫管理APIが未実装だった場合の app/controllers/stock_controller.rb
class StocksController < ApplicationController
  def create
    stock = DummyStock.new(stock_params)

    if stock.save
      redirect_to new_stock_url, flash: { success: "在庫作成が完了しました！"}
    else
      flash.now[:alert] = stock.errors.full_messages.join
      render :new
    end
  end
end

# 在庫管理APIが未実装だった場合の app/models/dummy_stock.rb
class DummyStock
  include ActiveModel::Model
  include ActiveModel::Attributes

  attr_accessor :product_code, :quantity
  attribute :verified, :boolean

  validates :product_code, presence: true
  validates :quantity, presence: true, numericality: { greater_than_or_equal: 1 }

  def save
    # バリデーションの動作だけ確認して、実際にAPIとの通信はしない
    validate
  end
end

=begin
また、テストがしやすくなるというメリットもある。
Stockクラスの動作を網羅的にテストすることが簡単になるほか、
表示の動作だけをテストしたいときも、ダミーのオブジェクトに置き換えることでAPIとの通信条件を考えなくて良くなる。

今回はシンプルな入庫処理を例に挙げたが、多くの場合はもっと複雑です。
例えば在庫を一括で登録するようなこともあるだろうし、決済とどうじに出荷処理を開始することもあるだろう。
こうした外部サービスの都合は専用のクラスに閉じ込めてある方が扱いやすく、変更が発生した際もその影響範囲をコントロールしやすくなる。
=end
