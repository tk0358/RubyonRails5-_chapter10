# 10-7-2-1
# case1 多少変わった形のparamsからの代入コードをモデルに寄せる
# 変更後モデル　app/models/user.rb
# 画面の都合に合わせたリクエストパラメータをモデルでそのまま受け取って、モデル側でデータベース形式に変換するとうまくいく

class User < ApplicationRecord
  attr_writer :zip1, :zip2  # 4. zip1やzip2という属性の受け取り口をモデルに用意する

  before_validation :set_zip_cocde # 6. コントローラの5で受け取った郵便番号のパーツ情報は、before_validationコールバックで検証前に組み立てられ、zip_codeに代入される

  def zip1
    @zip1 ||= zip_code.present? ? zip_code.split('-').first : nil
  end

  def zip2
    @zip2 ||= zip_code.present? ? zip_code.split('-').last : nil
  end

  private
  def set_zip_code
    self.zip_code = zip1.present? && zip2.present? ? [zip1, zip2].join('-') : nil
  end
end
