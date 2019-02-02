module Forecastable
  def forecast
    city.name == '長岡' ? '雪' : '晴れ'
  end
end
