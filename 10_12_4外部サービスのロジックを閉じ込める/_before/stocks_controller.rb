=begin
あるRailsアプリケーションは関連サービスを横断して在庫情報を管理しており、
そのための在庫管理アプリケーションを独立したサーバで運用している。
在庫管理アプリケーションはAPIを提供していて（以下、在庫管理APIと呼ぶ）、
各サービスはそのAPIを利用して在庫状態を確認したり更新したりする。
APIはJSON形式でデータを送信するものとする。

この在庫管理APIを利用して入庫処理を行う画面を実装してみよう。
この画面には、以下の仕様があるとする

◯管理者はフォームから以下を入力する
・商品コード
・入庫する数量
・点検済みかどうか
◯商品コードと数量はバリデーションを行い、必要に応じてエラーメッセージを表示する
◯バリデーションが成功したら、在庫管理APIへのリクエストを組み立てて送信する

APIとのやりとりに関しては、次のような仕様を満たす必要があるものとする。
◯リクエストの際、点検済みかどうかはJSON内でブール値（true/false）として送信したい
◯リクエストに失敗したら、その旨のエラーメッセージを表示したい
◯成功のレスポンスが返ってきたら、成功メッセージを表示したい
◯失敗のレスポンスが帰ってきたら、エラー内容に応じた失敗メッセージを表示したい

これらの仕様を素直にコントローラに実装すると、次のようになる。
=end

 #app/controllers/stocks_controller.rb(変更前)
require 'net/http'

class StocksController < ApplicationController
  def create
    errors = validate_stock_params   # <- 1～
    if errors.present?
      flash.now[:alsert] = errors.join
      render :new
      return
    end                              # <- ～1

    body = {  # <- 2~
      product_code: stock_params[:product_code],
      quantity: stock_params[:quantity],
      verified: stock_params[:verified] == "1"
    }.to_json  # <- ~2

    begin   # <- 3~
      response = Net::HTTP.post(
        URI('http://localhost:1323/stocks'),
        body,
        "Content-Type" => "application/json"
      )
    rescue => e
      redirect_to new_stock_url, flash: { alert: "在庫管理システムに接続できませんでした" }
      logger.error e.full_message
      return
    end   # <- ~3

    if response.code == '200'     # <- 4~
      redirect_to new_stock_url, flash: { success: "在庫作成が完了しました！" }
    else
      flash.now[:alert] = error_message_from_response(response)
      render :new
    end                           # <- ~4
  end

  private

  def stock_params
    params.require(:stock).permit(:product_code, :quantity, :verified)
  end

  def validate_stock_params
    [].tap do |errors|
      errors << "商品コードを指定してください。" if stock_params[:product_code].blank?
      errors << "数量を指定してください。" if stock_params[:quantity].blank?
      errors << "数量は１以上の数で指定してください。" if stock_params[:quantity].to_i <= 0
    end
  end

  def error_message_from_response(response)
    error_code = JSON.parse(response.body)['error_code']

    case error_code
    when 'product_not_found'
      "指定の商品は存在しません。"
    when 'product_unavailable'
      "取扱終了商品です。"
    else
      "エラーが発生しました。code = #{error_code}"
    end
  end
end

=begin
このコードでは、管理者がフォームに入力した在庫情報をstock_params(params[:stock])で受け取り、それを検証して、問題があれば差し戻す( 1 )
問題がなければリクエストボディのJSONを組み立てる( 2 )
そのJSONを使って在庫管理APIにリクエストを送信し、エラーがあればエラーメッセージを表示する( 3 )
最後に、レスポンスの成否を調べ、然るべき対応を行う( 4 )

この実装は外部APIの扱いのためにかなりボリュームが多く、複雑になっている。
このようなときは、意味のつながりのあるデータや処理のまとまりに注目しよう。
すると、次のようなまとまりが見えてくる

データ{
◯入力情報
・商品コード
・入庫する数量
・点検済みかどうか
◯出力情報
・入庫の成否情報
}

処理{
管理者の入力内容を検証する
検証が通る場合は、在庫管理APIに入庫のリクエストを送る
在庫管理APIからのレスポンスを解析する
}

次にこのようなまとまりを、Rails風に表すことができないか考えてみよう。
在庫管理アプリケーションが「外部」にあるという事情がもしないとすれば、
入庫というのは、在庫情報をデータベースに登録することに似ている。
モデルの一般的な動き（検証・保存し結果がかえってくる）に当てはめることができる。
もちろん、必ずしもよくあるモデル風のI/Fに揃えなければいけないわけではないが、
やりたいことが似ている場合は揃えておくと、モデルの使い方をプログラマが類推できて便利。
それでは、このようなまとまりを表すStockクラスを、ActiveModelを活用して作ることにしよう。
（→after/stock.rb)

=end
