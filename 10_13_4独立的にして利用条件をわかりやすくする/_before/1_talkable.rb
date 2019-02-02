module Talkable
  def greeting
    "こんにちは、#{name}さん。#{city.name}の天気は#{forecast}です！"
  end
end

=begin
この例では、「Talkable#greeting」を実行するためには、AddressableとForecastableの両方が必要となる。
このようにモジュール同士の結合度が高いと、関連するモジュールを必ずセットでincludeしなければいけないため、使いづらくなる。

「歳を割り出して天気予報を行う」という役割のForecasterクラスを新設してForecastableとAddressableの役割を担わせ、
greetingの引数としてポータブルに渡す方法がある。(->after/talkable.rb, forecaster.rb)
=end
