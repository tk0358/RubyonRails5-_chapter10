# ECアプリにおいて、注文(Order)クラスと商品(Product)クラスがそれぞれ、
# 共通処理を独立させたTaxCalculatorクラスを使って消費税計算を行う

#TaxCalculatorクラス
class TaxCalculator
  def self.with_tax(amount, on: date)
    # 指定された日の消費税率で金額を計算して結果を返す
    ...
  end
end

#Orderクラス
class Order < ApplicationRecord
  def tax_included_amount
    TaxCalculator.with_tax(amount, on: created_on)
  end
end

#Productクラス
class Product < ApplicationRecord
  def tax_included_unit_price(date)
    TaxCalculator.with_tax(unit_price, on: date)
  end
end
