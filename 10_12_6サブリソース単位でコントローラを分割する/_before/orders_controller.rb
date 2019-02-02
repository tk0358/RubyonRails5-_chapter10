=begin
同じコントローラに次々にアクションを追加していくと、コントローラの見通しが次第に悪くなってしまう。

たとえば、次に示すように、注文の帳票一括出力機能やCSVのエクスポート・インポート機能といったアクションを、
同じOrdersControllerにアクションを追加していったらどうなるか？
次のように、さまざまなアクションがずらりと並ぶ巨大なコントローラファイルが出来上がる
=end

class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy, :report]

  def index
    ...
  end

  def show
    ...
  end

  def new
    ...
  end

  def edit
    ...
  end

  def create
    ...
  end

  def update
    ...
  end

  def destroy
    ...
  end

  def report
    ...
  end

  def summary_report
    ...
  end

  def csv_export
    ...
  end

  def csv_import
    ...
  end

  private

  def set_order
    ...
  end

  def order_params
    ...
  end
end

=begin
注文(OrdersController)からは注文の帳票(OrderReportsController)と注文のCSV(OrderCsvsController)といったサブリソースごとのコントローラに分けることが出来る

=end
