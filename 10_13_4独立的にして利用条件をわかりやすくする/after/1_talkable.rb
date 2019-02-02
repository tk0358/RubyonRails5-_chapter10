module Talkable
  def greeting(forecaster)
    "こんにちは、#{name}さん。#{forecaster.city_name}の天気は#{forecaster.weather}です！"
  end
end
